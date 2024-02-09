--
--
--
--
pcall(require, "luarocks.loader")
-- Importa o módulo awful
local awful = require("awful")

    -- Função para lançar um terminal com um comando específico em um monitor específico
local function launch_terminal_on_screen(screen_number, command)
    -- Define o monitor focado
   awful.screen.focused(screen_number)
    -- Lança o terminal com o comando especificado
   awful.spawn("alacritty -e " .. command)
end

    -- Lança os terminais
launch_terminal_on_screen(3, "btop")
launch_terminal_on_screen(1, "fastfetch")
launch_terminal_on_screen(1, "htop")
launch_terminal_on_screen(2, "radeontop")
launch_terminal_on_screen(2, "htop")
