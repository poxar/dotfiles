#!/bin/zsh

(xrandr -q | grep -o 'HDMI2 connected' && xrandr --output LVDS1 --auto --left-of HDMI2 --output HDMI2 --auto)
([[ -e ~/.fehbg ]] && sh ~/.fehbg)
xbindkeys
urxvtd -q -o -f

run_once nm-applet
(sleep 3 && dropboxd)
