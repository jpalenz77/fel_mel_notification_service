import xbmc
import subprocess

SCRIPT_PATH = "/storage/.kodi/userdata/fel_mel_notification.sh"

class PlaybackMonitor(xbmc.Player):
    def onPlayBackStarted(self):
        try:
            subprocess.Popen([SCRIPT_PATH])
        except Exception as e:
            xbmc.log(f"FEL/MEL Service Error: {str(e)}", xbmc.LOGERROR)

if __name__ == "__main__":
    monitor = xbmc.Monitor()
    player = PlaybackMonitor()
    
    while not monitor.abortRequested():
        if monitor.waitForAbort(1):
            break
