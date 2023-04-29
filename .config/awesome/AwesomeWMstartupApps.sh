#!/usr/bin/env bash
#
#
#           Not working
#          Now will work!!
#
#
#
#yakuake &
killall gammastep ;
gammastep &
picom --daemon --config $HOME/.config/picom/picom.conf &
sleep 1 && /usr/libexec/polkit-gnome-authentication-agent-1 &
