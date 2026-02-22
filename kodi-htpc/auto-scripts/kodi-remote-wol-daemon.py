#!/usr/bin/python3
import subprocess
import sys
import socket
import uuid

KODI_SERVICE = "kodi-gbm.service"


def log(msg: str):
    """Simple logging to stdout/stderr for systemd journal."""
    print(msg, flush=True)


def get_mac_bytes():
    mac_int = uuid.getnode()
    return mac_int.to_bytes(6, byteorder="big")


def is_valid_wol_packet(data: bytes) -> bool:
    """
    Validate that this is a WoL packet for this machine's MAC address.
    """
    # WoL packets are 6 x 0xFF followed by MAC repeated 16 times
    if len(data) < 102:
        return False

    if not data.startswith(b"\xff" * 6):
        return False

    mac_bytes = get_mac_bytes()

    # WoL payload = MAC repeated 16 times
    return data[6:] == mac_bytes * 16


def is_service_active(service_name: str):
    """Check if a systemd service is active."""
    result = subprocess.run(
        ["systemctl", "is-active", service_name],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    return result.stdout.strip() == "active"


def start_service(service_name: str):
    """Start a systemd service."""
    _ = subprocess.Popen(["systemctl", "start", service_name])


def try_start_kodi():
    if is_service_active(KODI_SERVICE):
        log(f"{KODI_SERVICE} is already running. Nothing to do.")
    else:
        log(f"Starting {KODI_SERVICE}...")
        _ = subprocess.Popen(["systemctl", "start", KODI_SERVICE])


def is_valid_wol(msg: str):
    # TODO: Implement
    return True


def main():
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    # WOL always on port 9, so not configurable
    sock.bind(("", 9))

    print("Listening for broadcast WoL on port 9...")

    while True:
        # Known fixed length for WOL packet
        data, addr = sock.recvfrom(2048)
        try:
            text = data.decode("utf-8")
            log(f"UDP packet received from {addr[0]}: {text}")
            if is_valid_wol(text):
                try_start_kodi()
        except UnicodeDecodeError:
            log(f"UDP packet received from {addr[0]} (non-text, hex): {data.hex()}")
            # WOL packet is hex: 6 bytes of 255 (0xFF) and then 16 repetitions of the mac address
            if is_valid_wol_packet(data):
                try_start_kodi()
            else:
                log("WOL packet invalid! Disregarding.")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Error in main: {e}", file=sys.stderr, flush=True)
