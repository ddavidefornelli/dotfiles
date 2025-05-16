#!/bin/bash

# Script per rilevare quando un monitor viene collegato o scollegato
# e spostare i workspace di conseguenza

move_workspaces_to_laptop() {
    for i in {1..10}; do
        hyprctl dispatch workspace "$i" >/dev/null
        hyprctl dispatch moveworkspacetomonitor "$i" eDP-1 >/dev/null
    done
    # Torna al workspace 1
    hyprctl dispatch workspace 1 >/dev/null
    echo "Tutti i workspace spostati sul laptop (eDP-1)"
}

move_workspaces_to_hdmi() {
    for i in {1..10}; do
        hyprctl dispatch workspace "$i" >/dev/null
        hyprctl dispatch moveworkspacetomonitor "$i" HDMI-A-1 >/dev/null
    done
    # Torna al workspace 1
    hyprctl dispatch workspace 1 >/dev/null
    echo "Tutti i workspace spostati sul monitor HDMI (HDMI-A-1)"
}

# Funzione per controllare se HDMI-A-1 è connesso
check_hdmi_connected() {
    if hyprctl monitors | grep "HDMI-A-1" >/dev/null; then
        return 0  # HDMI è connesso
    else
        return 1  # HDMI non è connesso
    fi
}

# Monitoraggio iniziale
if check_hdmi_connected; then
    move_workspaces_to_hdmi
else
    move_workspaces_to_laptop
fi

# Continua a monitorare i cambiamenti
socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r line; do
    if echo "$line" | grep "monitoradded" | grep "HDMI-A-1" >/dev/null; then
        move_workspaces_to_hdmi
    elif echo "$line" | grep "monitorremoved" | grep "HDMI-A-1" >/dev/null; then
        move_workspaces_to_laptop
    fi
done
