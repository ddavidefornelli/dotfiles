#!/bin/bash

# --- Avvio DBUS se non esiste ---
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
    export DBUS_SESSION_BUS_ADDRESS
    export DBUS_SESSION_BUS_PID
fi

# --- Avvio Hyprland ---
exec Hyprland &
HYPR_PID=$!

# --- Attendere che Hyprland sia pronto ---
sleep 3  # aumentare se necessario

# --- Avvio Hyprpaper solo se non è già in esecuzione ---
if ! pgrep -x hyprpaper > /dev/null; then
    setsid hyprpaper &
fi

# --- Avvio Waybar ---
setsid waybar &

# --- Mantieni lo script in esecuzione finché Hyprland è vivo ---
wait $HYPR_PID

