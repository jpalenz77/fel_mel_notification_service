#!/bin/bash
DEBUG_PATH="/sys/class/amdolby_vision/debug"
SRC_FMT="/sys/class/video_poll/primary_src_fmt"

# Espera breve al inicio para que la info de video esté lista
sleep 3

# Salir si no hay información de video
[ ! -f "$SRC_FMT" ] && exit 0

# Leer tipo de fuente
SRC_VALUE=$(cat "$SRC_FMT" 2>/dev/null | tr -d '\0')

# Función para mostrar notificación
show_notification() {
    kodi-send --action="Notification($1,$2,10000)"
}

# Solo si es Dolby Vision, comprobamos FEL/MEL
if echo "$SRC_VALUE" | grep -qi "Dolby"; then
    BEFORE=$(dmesg | tail -n 300)
    echo dv_el > "$DEBUG_PATH" 2>/dev/null
    sleep 1
    AFTER=$(dmesg | tail -n 300)
    NEW_LOGS=$(echo "$AFTER" | grep -Fvx -f <(echo "$BEFORE"))

    if echo "$NEW_LOGS" | grep -q "el_mode:1"; then
        show_notification "Dolby Vision" "FEL detected"
    elif echo "$NEW_LOGS" | grep -q "el_mode:0"; then
        show_notification "Dolby Vision" "MEL detected"
    fi
fi