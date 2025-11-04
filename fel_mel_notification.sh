#!/bin/bash

DEBUG_PATH="/sys/class/amdolby_vision/debug"
SRC_FMT="/sys/class/video_poll/primary_src_fmt"

# Wait for playback to initialize
sleep 2

# Exit if video info unavailable
if [ ! -f "$SRC_FMT" ]; then
    exit 0
fi

# Read current video format
SRC_VALUE=$(cat "$SRC_FMT" 2>/dev/null | tr -d '\0')

# Check if content is Dolby Vision
if echo "$SRC_VALUE" | grep -qi "Dolby"; then
    # Capture dmesg before triggering debug
    BEFORE=$(dmesg | tail -n 200)
    
    # Trigger EL mode detection
    echo dv_el > "$DEBUG_PATH" 2>/dev/null
    sleep 0.5
    
    # Capture new dmesg entries
    AFTER=$(dmesg | tail -n 200)
    NEW_LOGS=$(echo "$AFTER" | grep -Fvx -f <(echo "$BEFORE"))

    # Detect FEL (Profile 7) or MEL (Profile 8)
    if echo "$NEW_LOGS" | grep -q "el_mode:1"; then
        kodi-send --action="Notification(Dolby Vision,FEL (Profile 7),10000)"
    else
        kodi-send --action="Notification(Dolby Vision,MEL (Profile 8),10000)"
    fi
fi

exit 0
