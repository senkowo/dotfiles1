#!/bin/bash

while true; do
	dbus-launch --sh-syntax --exit-with-session dwm 2> ~/.dwm.log
	#dwm 2> ~/.dwm.log
done
