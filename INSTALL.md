# Installation Guide

## Quick Install Instructions

### Step 1: Upload Files to CoreELEC

Transfer this entire folder to your CoreELEC device via SSH/SFTP.

### Step 2: Install the Add-on

```bash
# Copy the add-on folder to Kodi's addon directory
cp -r service.fel_mel_notification /storage/.kodi/addons/

# Copy the detection script to userdata
cp fel_mel_notification.sh /storage/.kodi/userdata/

# Make the script executable
chmod +x /storage/.kodi/userdata/fel_mel_notification.sh
```

### Step 3: Restart Kodi

```bash
systemctl restart kodi
```

Or simply reboot your CoreELEC device.

### Step 4: Test

Play a Dolby Vision video and look for the notification in the top-left corner.

---

## Manual Installation (Alternative)

If you prefer to create files manually:

1. SSH into your CoreELEC device
2. Create the addon directory:
   ```bash
   mkdir -p /storage/.kodi/addons/service.fel_mel_notification
   ```
3. Create each file using `nano` or `vi` and paste the contents from the respective files
4. Set proper permissions and restart Kodi

---

## Troubleshooting

- Check Kodi logs: `tail -f /storage/.kodi/temp/kodi.log`
- Verify script permissions: `ls -l /storage/.kodi/userdata/fel_mel_notification.sh`
- Test script manually: `/storage/.kodi/userdata/fel_mel_notification.sh`

---

## File Structure

```
fel-mel-addon/
├── README.md                           # Main documentation
├── INSTALL.md                          # This file
├── fel_mel_notification.sh             # Detection script (goes to userdata)
└── service.fel_mel_notification/       # Kodi addon folder
    ├── addon.xml                       # Addon manifest
    ├── service.py                      # Python service
    └── resources/                      # Icons for notifications
        ├── fel_icon.png                # FEL notification icon
        └── mel_icon.png                # MEL notification icon
```
