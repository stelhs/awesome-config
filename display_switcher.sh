#!/bin/bash
xrandr --output eDP-1 --auto --output HDMI-1 --auto
sleep 1
xrandr --output eDP-1 --primary --below HDMI-1