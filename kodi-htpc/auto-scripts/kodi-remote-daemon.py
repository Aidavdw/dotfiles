#!/usr/bin/python3

# Roughly based on https://github.com/danifr/wol-kodi/blob/python/wolkodi.py

import socket
import subprocess
import sys

UDP_PORT = 5600
KODI_SERVICE = "kodi-gbm.service"


def log(msg: str):
    """Simple logging to stdout/stderr for systemd journal."""
    print(msg, flush=True)


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


def main():
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(("0.0.0.0", UDP_PORT))
    log(f"Listening for UDP packets on port {UDP_PORT}")

    while True:
        # Biggest possible UDP packet, so anything should be able to fit
        data, addr = sock.recvfrom(65535)
        try:
            text = data.decode("utf-8")
            log(f"UDP packet received from {addr[0]}: {text}")
        except UnicodeDecodeError:
            log(f"UDP packet received from {addr[0]} (non-text, hex): {data.hex()}")

        if is_service_active(KODI_SERVICE):
            log(f"{KODI_SERVICE} is already running. Nothing to do.")
        else:
            log(f"Starting {KODI_SERVICE}...")
            start_service(KODI_SERVICE)
            log(f"{KODI_SERVICE} has been started :-)")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Error in main: {e}", file=sys.stderr, flush=True)
