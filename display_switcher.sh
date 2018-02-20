#!/bin/bash
xrandr --output LVDS1 --auto --output HDMI1 --auto
sleep 1
xrandr --output LVDS1 --primary --below HDMI1
