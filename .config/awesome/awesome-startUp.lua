



local awful = require("awful")

-- abre o terminal no monitor especificado e executa o comando especificado
awful.spawn("alacritty -e btop", {screen = 2})
awful.spawn("alacritty -e htop", {screen = 0})
awful.spawn("alacritty", {screen = 0})
awful.spawn("alacritty -e radeontop", {screen = 1})
awful.spawn("alacritty -e htop", {screen = 1})