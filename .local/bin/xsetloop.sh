#!/bin/bash

while true; do

	volume=$(pactl get-sink-volume 0 | awk '{print $5}' | sed s/%//)
	mute=$(pactl get-sink-mute 0 | awk '{print $2}')
	symbol_vol=

	if [ "$mute" = "yes" ]; then
		symbol_vol=
	elif (($volume >= 30)); then
		symbol_vol=
	elif (($volume < 30)) && (($volume > 0)); then 
		symbol_vol=
	elif (($volume == 0)); then
		symbol_vol=
	else 
		symbol_vol="NA"
	fi


	battery=$(acpi -b | awk '{print $4}' | sed s/%,//)

	if (($battery >= 80)); then
		battery=
	elif (($battery < 80)) && (($battery >= 60)); then
		battery=
	elif (($battery < 60)) && (($battery >= 40)); then
		battery=
	elif (($battery < 40)) && (($battery >= 15)); then
		battery=
	elif (($battery < 15)); then
		battery=
	else
		battery="NA"
	fi

	date=$(date '+%b %d %a')
	time=$(date '+%H:%M')

	xsetroot -name " $symbol_vol $volume% | $battery | $date | $time "
	sleep 1
done
