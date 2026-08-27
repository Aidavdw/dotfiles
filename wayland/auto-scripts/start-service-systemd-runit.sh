#!/bin/sh

set -u

PROG=${0##*/}

SYSTEMD_SERVICE=
RUNIT_SERVICE=
ACTION=start

notify_error() {
    notify-send \
        --urgency=critical \
        --app-name="$PROG" \
        "Niri service error" \
        "$1"
}

usage() {
    cat <<EOF
Usage: $PROG [--systemd SERVICE] [--runit SERVICE] [--stop]

Options:
  --systemd SERVICE   systemd user service name
  --runit SERVICE     runit user service name
  --stop              stop instead of start
  -h, --help          show this help
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
    --systemd)
        [ "$#" -ge 2 ] || {
            usage >&2
            exit 2
        }
        SYSTEMD_SERVICE=$2
        shift 2
        ;;

    --runit)
        [ "$#" -ge 2 ] || {
            usage >&2
            exit 2
        }
        RUNIT_SERVICE=$2
        shift 2
        ;;

    --stop)
        ACTION=stop
        shift
        ;;

    -h | --help)
        usage
        exit 0
        ;;

    *)
        printf '%s: unknown argument: %s\n' "$PROG" "$1" >&2
        usage >&2
        exit 2
        ;;
    esac
done

[ -n "$SYSTEMD_SERVICE" ] || [ -n "$RUNIT_SERVICE" ] || {
    notify_error "No service was specified."
    exit 2
}

# Detect the init system.

if command -v systemctl >/dev/null 2>&1 &&
    systemctl --user show-environment >/dev/null 2>&1; then
    INIT=systemd
elif command -v sv >/dev/null 2>&1 &&
    [ -d "$HOME/.config/service" ]; then
    INIT=runit
else
    notify_error "Could not determine the init system."
    exit 1
fi

case "$INIT" in
systemd)
    [ -n "$SYSTEMD_SERVICE" ] || {
        notify_error "No systemd service was specified."
        exit 2
    }

    case "$ACTION" in
    start)
        if systemctl --user start "$SYSTEMD_SERVICE"; then
            exit 0
        fi

        status=$?
        if [ "$status" -eq 4 ]; then
            notify_error "systemd service not found: $SYSTEMD_SERVICE"
        else
            notify_error "Failed to start systemd service: $SYSTEMD_SERVICE"
        fi
        exit 1
        ;;

    stop)
        if systemctl --user stop "$SYSTEMD_SERVICE"; then
            exit 0
        fi

        status=$?
        if [ "$status" -eq 4 ]; then
            notify_error "systemd service not found: $SYSTEMD_SERVICE"
        else
            notify_error "Failed to stop systemd service: $SYSTEMD_SERVICE"
        fi
        exit 1
        ;;
    esac

    ;;

runit)
    [ -n "$RUNIT_SERVICE" ] || {
        notify_error "No runit service was specified."
        exit 2
    }

    enabled_service_dir="$HOME/.config/service"

    # Turnstile's user services live here.
    service="$enabled_service_dir/$RUNIT_SERVICE"

    if [ ! -d "$service" ]; then
        notify_error "runit service not found: $RUNIT_SERVICE"
        exit 1
    fi

    # Tell sv explicitly which service directory to use.
    if [ "$ACTION" = start ]; then
        SVDIR="$enabled_service_dir" sv up "$RUNIT_SERVICE" || {
            notify_error "Failed to start runit service: $RUNIT_SERVICE"
            exit 1
        }
    else
        SVDIR="$enabled_service_dir" sv down "$RUNIT_SERVICE" || {
            notify_error "Failed to stop runit service: $RUNIT_SERVICE"
            exit 1
        }
    fi
    ;;
esac
