#!/usr/bin/env bash
#
#
#
sh /home/jkyon/.screenlayout/arandr.config.sh
feh --no-xinerama --bg-fill ~/Pictures/Wallpapers/LinuxWallpapers/multi-monitor-wallpapers.jpg
picom --config /home/jkyon/.config/picom/picom.conf --log-file /home/jkyon/.dotfiles/.config/picom/picom.log --daemon --backend glx &

#gammastep -x && gammastep &
if ! pgrep -x "gammastep" > /dev/null
then
    gammastep &
fi

if ! pgrep -x "xfce4-clipman" > /dev/null
then
    xfce4-clipman &
fi

if ! pgrep -x "openrgb" > /dev/null
then
    openrgb --startminimized &
fi

sleep 1 && /usr/libexec/polkit-gnome-authentication-agent-1 &
