#!/bin/bash

case $1 in
	"")
		echo "Error: No arguments provided"
		exit 1
		;;
	"-h"|"--help")
		echo "Help: command %fileToConvert %filename(opt) %--rate=<Hz>(opt)"
		exit 0
		;;
#
#	*)
#		[[ ! -f ./$1 ]] && echo "This file does not exist. Exiting..." && exit 1
#		;;
esac

echo "Starting audio recorder..."

#<< comment1

trap "exit" INT TERM ERR
trap "kill 0" EXIT

## Spawn Audio Recorder as Process -- $2 as filename.
DATE=$(date +"%F_%T")

#parec -d alsa_output.pci-0000_00_1f.3.analog-stereo.monitor | lame -r -V0 - ~/Music/$2_$DATE.mp3 &
ffmpeg -f pulse -i 46 ~/Music/$2_$DATE.wav &

## Spawn aplay and wait -- $1 as location
aplay $1 $3 &
PID=$!

wait $PID

echo "aplay is finished"

# SIGINT the audio recorder to end recording
echo "before kill all"

#killall -s SIGINT ffmpeg

echo "killed all"

#comment1


<< comment2

## Spawn Audio Recorder as Process -- $2 as filename.

DATE=$(date +"%F_%T")

exec parec -d alsa_output.pci-0000_00_1f.3.analog-stereo.monitor | lame -r -V0 - ~/Music/$2_$DATE.mp3 &

comment2


