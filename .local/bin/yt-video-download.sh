#!/bin/bash

yt-dlp $1 --list-formats

echo -en "\nEnter format number (default 22):\n> "
read format

yt-dlp $1 --format $format --embed-thumbnail -w -o "~/Downloads/elia-downloads/%(title)s.%(ext)s" -v --write-description

