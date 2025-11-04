import xbmc
import xbmcgui
import subprocess
import time

# Path to bash script
SCRIPT_PATH = "/storage/.kodi/userdata/fel_mel_notification.sh"

while not xbmc.Monitor().abortRequested():
    # Wait for a player to start
    if xbmc.Player().isPlayingVideo():
        # Execute your script
        subprocess.Popen([SCRIPT_PATH])

        # Wait for playback to finish to avoid running it again
        while xbmc.Player().isPlayingVideo():
            if xbmc.Monitor().abortRequested():
                break
            time.sleep(1)

    time.sleep(1)
