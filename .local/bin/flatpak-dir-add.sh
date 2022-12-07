#!/bin/bash

if [ -z "$1" ]; then
	echo "> No parameters given"
	echo "\$1 should be flatpak package name"
	echo "\$2 should be directory"
	echo "Here's a list of flatpak packages:"
	echo "$(flatpak list --app | awk '{print "| " $2}')"
	echo 
	exit 1
fi

if [ -z "$2" ]; then
	echo "> Second parameter not given"
	echo "\$2 should be directory"
	echo 
	exit 1
fi

doas flatpak override $1 --filesystem=$2

