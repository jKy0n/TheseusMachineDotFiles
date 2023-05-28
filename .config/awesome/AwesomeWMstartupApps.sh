#!/usr/bin/env bash
#
#
#           Not working
#          Now will work!!
#
#
#
#yakuake &
gammastep -x &&
gammastep &
#picom --daemon --config $HOME/.config/picom/picom.conf &
picom --experimental-backend &
sleep 1 && /usr/libexec/polkit-gnome-authentication-agent-1 &
