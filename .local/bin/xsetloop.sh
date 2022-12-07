#!/bin/bash

while true; do

	date=$(date +'%Y-%m-%d %I:%M:%S %p')

	#battery=$(acpi -b | awk '{print $4}' | sed s/%,//)
	battery=$(cat /sys/class/power_supply/BAT0/capacity)
	bat_status=$(cat /sys/class/power_supply/BAT0/status)

	volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed s/%//)

	mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

    brightness_abs=$(cat /sys/class/backlight/intel_backlight/brightness)
    brightness_max_abs=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    brightness=$(bc -l <<< "scale=2 ; $brightness_abs / $brightness_max_abs" | sed s/^\.//)
    
    firejail=$(~/.local/bin/firejail-print-num.sh)
    
    ## Symbols ##
    
    bat_sym=""
    if [ "$bat_status" = "Charging" ]; then
    	bat_sym=
    elif [ "$bat_status" = "Full" ]; then
    	bat_sym=Full
    	battery=""
    elif (($battery < 15)); then
    	bat_sym=
    elif (($battery < 40)); then
    	bat_sym=
    elif (($battery < 60)); then
    	bat_sym=
    elif (($battery < 80)); then
    	bat_sym=
    elif (($battery >= 80)); then
    	bat_sym=
    else 
    	bat_sym="NA"
    fi
    
    
    vol_sym=""
    if [ "$mute" = "yes" ]; then
    	vol_sym=
    	volume=""
    elif (($volume <= 0)); then
    	vol_sym=
    elif (($volume < 30)); then 
    	vol_sym=
    elif (($volume >= 30)); then
    	vol_sym=
    else 
    	vol_sym="NA"
    fi
    
    
    xsetroot -name " fj: $firejail | $vol_sym $volume |  $brightness | $bat_sym $battery | $date "

	sleep 1
done
