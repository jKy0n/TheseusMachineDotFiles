#!/usr/bin/env bash
feh --bg-fill --no-xinerama ~/Pictures/Wallpapers/LinuxWallpapers/multi-monitor-wallpapers.jpg
picom --daemon &
nice -n 15 dwmblocks &
sleep 1 && /usr/libexec/polkit-gnome-authentication-agent-1 &
