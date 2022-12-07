#!/bin/bash

URL="https://www.youtube.com/channel/UCCBEemCcJZ4lovTWIZmTUKQ"

# cd ~/Downloads
#/usr/bin/yt-dlp --format 140 --embed-thumbnail --download-archive "~/Music/_elia-downloader/elia-downloaded.txt" -ciw -o "~/Downloads/elia-downloads/%(title)s.%(ext)s" -v $URL
yt-dlp --format 140 --embed-thumbnail --download-archive "~/Music/_elia-downloader/elia-downloaded.txt" -ciw -o "~/Music/_elia-downloader/elia-downloads/%(title)s.%(ext)s" -v $URL
