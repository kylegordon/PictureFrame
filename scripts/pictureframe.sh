#!/bin/bash

export DISPLAY=:0.0 
export XAUTHORITY=/home/pi/.Xauthority
pkill xscreensaver
feh --auto-rotate --zoom fill -F -z -Y -D 30 /home/pi/Pictures/ &
xset s noblank
xset s off
xset s -dpms
