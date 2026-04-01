#!/usr/bin/env python3

import os
import json
import random
import socket
import subprocess
import time
from pathlib import Path

USE_DEFAULT_WALLPAPER = False
DEFAULT_WALLPAPER = Path.home() / ".config/swww-per-workspace/default.png"
SOURCE_DIR = Path.home() / ".config/swww-per-workspace"


# -------------------------
# Session Detection
# -------------------------
def detect_session():
    env_vars = [
        os.environ.get("XDG_CURRENT_DESKTOP", ""),
        os.environ.get("XDG_SESSION_DESKTOP", ""),
        os.environ.get("DESKTOP_SESSION", ""),
    ]

    for var in env_vars:
        if "hyprland" in var.lower():
            return "hyprland"
        if "niri" in var.lower():
            return "niri"

    # fallback
    try:
        subprocess.run(
            ["pgrep", "-x", "Hyprland"], check=True, stdout=subprocess.DEVNULL
        )
        return "hyprland"
    except subprocess.CalledProcessError:
        pass

    try:
        subprocess.run(["pgrep", "-x", "niri"], check=True, stdout=subprocess.DEVNULL)
        return "niri"
    except subprocess.CalledProcessError:
        pass

    return None


# -------------------------
# Core Wallpaper Logic
# -------------------------
def set_wallpaper_for_monitor(monitor, workspace):
    print(f"Switching to workspace {workspace} on {monitor}")

    temp_override = Path(f"/tmp/swww-per-workspace/{workspace}.png")

    # find matching file
    ws_path = next(SOURCE_DIR.glob(f"{workspace}*"), None)

    if temp_override.exists():
        print(f"Using temp override: {temp_override}")
        file = temp_override
    elif ws_path and ws_path.exists():
        print(f"Using dedicated file: {ws_path}")
        file = ws_path
    else:
        if USE_DEFAULT_WALLPAPER:
            print("Using default wallpaper")
            file = DEFAULT_WALLPAPER
        else:
            print("No wallpaper found, skipping")
            return

    rand_one = f"{random.random():.3f}"
    rand_two = f"{random.random():.3f}"

    subprocess.run(
        [
            "awww",
            "img",
            "--outputs",
            monitor,
            "--transition-type",
            "outer",
            "--transition-fps",
            "60",
            "--transition-step",
            "60",
            "--transition-bezier",
            ".36,.11,.17,.93",
            "--transition-duration",
            "1.5",
            "--transition-pos",
            f"{rand_one},{rand_two}",
            str(file),
        ]
    )


# -------------------------
# Hyprland Backend
# -------------------------
def hyprctl_json(cmd):
    result = subprocess.run(["hyprctl", "-j"] + cmd, capture_output=True, text=True)
    return json.loads(result.stdout)


def get_active_monitor_and_workspace():
    monitors = hyprctl_json(["monitors"])
    for m in monitors:
        if m.get("focused"):
            return m["name"], m["activeWorkspace"]["id"]
    return None, None


def set_wallpapers_all_monitors():
    monitors = hyprctl_json(["monitors"])
    for m in monitors:
        set_wallpaper_for_monitor(m["name"], m["activeWorkspace"]["id"])


def run_hyprland():
    runtime = os.environ["XDG_RUNTIME_DIR"]
    sig = os.environ["HYPRLAND_INSTANCE_SIGNATURE"]
    socket_path = f"{runtime}/hypr/{sig}/.socket2.sock"

    # wait for awww
    while True:
        if (
            subprocess.run(
                ["awww", "query"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
            ).returncode
            == 0
        ):
            break
        time.sleep(0.2)

    set_wallpapers_all_monitors()

    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
        sock.connect(socket_path)
        f = sock.makefile()

        for line in f:
            if line.startswith("workspace"):
                monitor, workspace = get_active_monitor_and_workspace()
                if monitor:
                    set_wallpaper_for_monitor(monitor, workspace)


# -------------------------
# Niri Backend
# -------------------------
def get_niri_focused_output():
    """
    You may need to adjust this depending on your setup.
    If Niri exposes a CLI or IPC query, use that here.

    Fallback: assume single monitor.
    """
    return "eDP-1"  # change if needed


def run_niri():
    socket_path = os.environ.get("NIRI_SOCKET")

    if not socket_path:
        raise RuntimeError("NIRI_SOCKET is not set")

    # wait for awww
    print("Waiting for awww to start up...")
    while True:
        if (
            subprocess.run(
                ["awww", "query"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
            ).returncode
            == 0
        ):
            break
        time.sleep(0.2)

    print("Setting up socket")

    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
        sock.connect(socket_path)

        # Send correct request
        request = json.dumps("EventStream") + "\n"
        sock.sendall(request.encode("utf-8"))

        # IMPORTANT: signal we're done sending
        sock.shutdown(socket.SHUT_WR)

        f = sock.makefile()

        print("Listening for events")
        for line in f:
            try:
                msg = json.loads(line)
            except json.JSONDecodeError:
                continue

            if "WorkspaceActivated" in msg:
                ws = msg["WorkspaceActivated"]

                if not ws.get("focused", False):
                    continue

                workspace_id = ws.get("id")
                monitor = get_niri_focused_output()

                set_wallpaper_for_monitor(monitor, workspace_id)


# -------------------------
# Main
# -------------------------
def main():
    session = detect_session()
    print(f"Detected session: {session}")

    if session == "hyprland":
        run_hyprland()
    elif session == "niri":
        run_niri()
    else:
        print("Unsupported session")
        exit(1)


if __name__ == "__main__":
    main()
