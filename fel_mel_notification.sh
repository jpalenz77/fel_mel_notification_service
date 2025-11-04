#!/bin/bash
DEBUG_PATH="/sys/class/amdolby_vision/debug"
SRC_FMT="/sys/class/video_poll/primary_src_fmt"

# Brief wait at the start for video info to be ready
sleep 3

# Exit if there's no video information
[ ! -f "$SRC_FMT" ] && exit 0

# Read source type
SRC_VALUE=$(cat "$SRC_FMT" 2>/dev/null | tr -d '\0')

# Function to show notification
show_notification() {
    kodi-send --action="Notification($1,$2,10000)"
}

# Only if it's Dolby Vision, check FEL/MEL
if echo "$SRC_VALUE" | grep -qi "Dolby"; then
    BEFORE=$(dmesg | tail -n 300)
    echo dv_el > "$DEBUG_PATH" 2>/dev/null
    sleep 1
    AFTER=$(dmesg | tail -n 300)
    NEW_LOGS=$(echo "$AFTER" | grep -Fvx -f <(echo "$BEFORE"))

    # FEL detection (Profile 7 - has full enhancement layer)
    if echo "$NEW_LOGS" | grep -q "el_mode:1"; then
        show_notification "Dolby Vision" "FEL detected"
    # MEL detection (Profile 8 - has minimal enhancement layer)
    # Only show MEL if el_mode:0 appears in NEW logs (not just existing logs)
    elif echo "$NEW_LOGS" | grep -qE "el_mode.*:.*0"; then
        show_notification "Dolby Vision" "MEL detected"
    fi
    # No notification for Profile 5 (standard DV without enhancement layer)
fi
