#!/bin/bash

# Avvia dbus se non è già attivo
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
    export DBUS_SESSION_BUS_ADDRESS
    export DBUS_SESSION_BUS_PID
fi

# Avvia Hyprland
exec Hyprland &
sleep 1  # piccolo delay per assicurarsi che Hyprland sia inizializzato

# Avvia Waybar e Hyprpaper
waybar &
hyprpaper &



