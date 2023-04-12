#!/usr/bin/env bash
picom --daemon &
dwmblocks &
sleep 1 && /usr/libexec/polkit-gnome-authentication-agent-1 &
feh --bg-fill --no-xinerama ~/Pictures/Wallpapers/LinuxWallpapers/multi-monitor-wallpapers.jpg

while type dwm >/dev/null; do dwm && continue || break; done
