#!/bin/sh

#sh ~/.local/bin/pipewire-start.sh &
#sh ~/.local/bin/sct-auto-adjust.sh &
#sh ~/.fehbg &
#picom &
exec dbus-launch --sh-syntax --exit-with-session dwm > ~/.dwm.log && sh ~/.local/bin/xsetloop.sh
#exec xsetroot -cursor_name left_ptr &

#exec dbus-launch --sh-syntax --exit-with-session xmonad

#exec dbus-launch --sh-syntax --exit-with-session cwm





