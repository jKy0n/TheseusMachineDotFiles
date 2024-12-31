-- ~/.config/awesome/dock.lua

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- Função para verificar e alternar janelas
local function toggle_or_launch(cmd, class)
    -- Procura uma janela com a classe especificada
    local clients = client.get()
    for _, c in ipairs(clients) do
        if c.class == class then
            -- Alterna para a janela, trazendo-a para o foco
            c:jump_to()
            return
        end
    end
    -- Se não encontrar, inicia o programa
    awful.spawn(cmd)
end

-- Função para criar a dock
local function create_dock()
    local dock = awful.wibar({
        position = "bottom",
        screen = screen.primary,
        height = 40,
        width = screen.primary.workarea.width,
        bg = "#00000080", -- Fundo preto com transparência
        fg = "#FFFFFF"
    })

    dock.ontop = false
    dock.x = screen.primary.geometry.width
    dock.y = screen.primary.geometry.height - dock.height

    -- Widgets da dock
    local my_launcher = wibox.widget {
        {
            image = "/usr/share/icons/hicolor/48x48/apps/firefox.png",
            resize = true,
            widget = wibox.widget.imagebox
        },
        margins = 5,
        widget = wibox.container.margin
    }

    -- Adiciona ação ao botão
    my_launcher:buttons(gears.table.join(
        awful.button({}, 1, function()
            toggle_or_launch("firefox", "Firefox") -- Altere "Firefox" para a classe correta
        end)
    ))

    -- Adiciona widgets à dock
    dock:setup {
        layout = wibox.layout.align.horizontal,
        nil,
        {
            layout = wibox.layout.align.horizontal,
            my_launcher, -- Adiciona o lançador
        },
        nil
    }
end

return create_dock