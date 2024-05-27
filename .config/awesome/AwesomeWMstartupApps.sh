#!/usr/bin/env bash
#
#
#
sh /home/jkyon/.screenlayout/arandr.config.sh
gammastep -x && gammastep &
feh --no-xinerama --bg-fill ~/Pictures/Wallpapers/LinuxWallpapers/multi-monitor-wallpapers.jpg
picom --config /home/jkyon/.config/picom/picom.conf --log-file /home/jkyon/.dotfiles/.config/picom/picom.log --daemon --backend glx &
xfce4-clipman &
sleep 1 && /usr/libexec/polkit-gnome-authentication-agent-1 &

if ! pgrep -x "openrgb" > /dev/null
then
    openrgb --startminimized &
fi

