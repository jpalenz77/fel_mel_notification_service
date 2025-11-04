# FEL/MEL Notification Service for Kodi on CoreELEC

This Kodi service add-on displays a notification in the **top-left corner** of the screen when a Dolby Vision video is played, showing **FEL** or **MEL**. SDR/HDR10 videos are ignored.

---

## Features

- Detects **Dolby Vision FEL/MEL** using CoreELEC system files.
- Shows a notification only at the **start of playback**.
- Compatible with **CoreELEC Amlogic CPM builds**.
- Works with Kodi skins supporting top-left notifications (e.g., Arctic Zephyr).

---

## Installation Paths on CoreELEC

### 1. Add-on Folder

/storage/.kodi/addons/service.fel_mel_notification/

yaml
Copy code

Place these files inside:

- `addon.xml`  
- `service.py`  
- `README.md` (optional)

---

### 2. Bash Script

Place the script in:

/storage/.kodi/userdata/fel_mel_notification.sh

bash
Copy code

Make it executable:

```bash
chmod +x /storage/.kodi/userdata/fel_mel_notification.sh
3. Update service.py
In service.py, point to the correct script path:

python
Copy code
SCRIPT_PATH = "/storage/.kodi/userdata/fel_mel_notification.sh"
4. addon.xml Example
xml
Copy code
<addon id="service.fel_mel_notification" version="1.0.0" name="FEL/MEL Notification Service" provider-name="YourName">
    <requires>
        <import addon="xbmc.python" version="3.0.0"/>
    </requires>
    <extension point="xbmc.service" library="service.py">
        <provides>video</provides>
    </extension>
</addon>
5. Bash Script (fel_mel_notification.sh)
bash
Copy code
#!/bin/bash
DEBUG_PATH="/sys/class/amdolby_vision/debug"
SRC_FMT="/sys/class/video_poll/primary_src_fmt"

# Wait briefly at the start of playback
sleep 2

# Exit if no video info
if [ ! -f "$SRC_FMT" ]; then
    exit 0
fi

# Read current video format
SRC_VALUE=$(cat "$SRC_FMT" 2>/dev/null | tr -d '\0')

# Check if it's Dolby Vision
if echo "$SRC_VALUE" | grep -qi "Dolby"; then
    # Capture dmesg before and after
    BEFORE=$(dmesg | tail -n 200)
    echo dv_el > "$DEBUG_PATH" 2>/dev/null
    sleep 0.5
    AFTER=$(dmesg | tail -n 200)
    NEW_LOGS=$(echo "$AFTER" | grep -Fvx -f <(echo "$BEFORE"))

    # FEL or MEL detection
    if echo "$NEW_LOGS" | grep -q "el_mode:1"; then
        kodi-send --action="Notification(Dolby Vision,FEL detected,10000)"
    else
        kodi-send --action="Notification(Dolby Vision,MEL detected,10000)"
    fi
else
    # Optional: ignore SDR/HDR10
    # kodi-send --action="Notification(Video,SDR/HDR10 detected,8000)"
    exit 0
fi
6. Restart Kodi
After installation:

bash
Copy code
systemctl restart kodi
or reboot CoreELEC.

7. Testing
Play a Dolby Vision video.

You should see a top-left notification:

Dolby Vision – FEL detected

Dolby Vision – MEL detected

Play SDR/HDR10 videos – no notification appears.

Notes
Adjust sleep in the script if notifications appear too early.

Works best with skins that support top-left notifications.

Check Kodi log for troubleshooting:

bash
Copy code
tail -f /storage/.kodi/temp/kodi.log
License
MIT License – feel free to fork and modify for personal use.

yaml
Copy code

---

I can also **prepare the full folder structure for GitHub** including `addon.xml`, `service.py`, and this `README.md` ready to push.  

Do you want me to do that next?