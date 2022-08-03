#!/bin/bash

dbus-launch --sh-syntax --exit-with-session; pulseaudio --kill; /usr/bin/gentoo-pipewire-launcher
