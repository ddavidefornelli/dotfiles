#!/bin/bash

# Controlla se HDMI è connesso
if hyprctl monitors | grep -q "HDMI-A-1"; then
    # Sposta tutti i workspace su HDMI
    for i in {1..10}; do
        hyprctl dispatch moveworkspacetomonitor "$i HDMI-A-1"
    done
else
    # Sposta tutto su eDP-1 se HDMI non è connesso
    for i in {1..10}; do
        hyprctl dispatch moveworkspacetomonitor "$i eDP-1"
    done
fi

