#!/bin/sh

sh ~/.local/bin/pipewire-start.sh &
sh ~/.local/bin/sct-auto-adjust.sh &
exec ~/.fehbg &

xrdb ~/.Xresources &
exec urxvtd --quiet --opendisplay --fork &

#picom & ### maybe not on dwm?
exec xsetroot -cursor_name left_ptr &

## xmonad only?
#exec trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent false --tint 0x5f5f5f --height 10 &
#exec xscreensaver -no-splash &
#if [ -x /usr/bin/nm-applet ] ; then
#	exec nm-applet --sm-disable &
#fi


#exec dbus-launch --sh-syntax --exit-with-session dwm > ~/.dwm.log
exec dbus-launch --sh-syntax --exit-with-session xmonad
#exec dbus-launch --sh-syntax --exit-with-session cwm
#exec dbus-launch --sh-syntax --exit-with-session herbstluftwm --locked



