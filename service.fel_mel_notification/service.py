import xbmc
import xbmcgui
import subprocess
import time

# Ruta al script bash
SCRIPT_PATH = "/storage/.kodi/userdata/fel_mel_notification.sh"

while not xbmc.Monitor().abortRequested():
    # Espera a que un reproductor inicie
    if xbmc.Player().isPlayingVideo():
        # Ejecuta tu script
        subprocess.Popen([SCRIPT_PATH])

        # Esperar a que termine la reproducción para no volver a ejecutarlo
        while xbmc.Player().isPlayingVideo():
            if xbmc.Monitor().abortRequested():
                break
            time.sleep(1)

    time.sleep(1)