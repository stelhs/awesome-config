#!/bin/bash
xrandr --output LVDS-1-1 --auto --output HDMI-1-1 --auto
sleep 1
xrandr --output LVDS-1-1 --primary --below HDMI-1-1
