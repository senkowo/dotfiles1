#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/Xresources
sysmodmap=/etc/X11/xinit/Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

#sh ~/.local/bin/pipewire-start.sh &
#sh ~/.local/bin/sct-auto-adjust.sh &
#sh ~/.fehbg &
#picom &
exec dbus-launch --sh-syntax --exit-with-session dwm > ~/.dwm.log && sh ~/.local/bin/xsetloop.sh
#exec xsetroot -cursor_name left_ptr &

#exec dbus-launch --sh-syntax --exit-with-session xmonad

#exec dbus-launch --sh-syntax --exit-with-session cwm





