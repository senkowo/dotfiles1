#!/bin/bash

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed s/%//)
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [[ "$muted" == "yes" ]]; then
	echo "muted"
else
	echo "vol:$volume"
fi
