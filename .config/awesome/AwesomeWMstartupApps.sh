#!/usr/bin/env bash
#
#
#           Not working
#          Now will work!!
#
#
#
#gammastep -x &&
#gammastep &
#picom --daemon --config $HOME/.config/picom/picom.conf &
#picom --experimental-backend &
picom --config /home/jkyon/.config/picom/picom.conf --log-file /home/jkyon/.dotfiles/.config/picom/picom.log --daemon --backend glx &
sleep 1 && /usr/libexec/polkit-gnome-authentication-agent-1 &

if ! pgrep -x "openrgb" > /dev/null
then
    openrgb --startminimized &
fi

