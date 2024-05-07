
-- -- Importando os módulos necessários
-- local awful = require("awful")
-- local wibox = require("wibox")

-- -- Criando o widget
-- local pkg_widget = wibox.widget.textbox()

-- -- Função para atualizar o widget
-- local function update_widget(widget)
--     -- Executando o comando para verificar atualizações
--     awful.spawn.easy_async("emerge -pvuND @world", function(stdout)
--         -- Procurando a linha que contém o total de pacotes
--         local total_line = stdout:match("(Total: %d+ packages)")
--         if total_line then
--             -- Extraindo o número de pacotes da linha
--             local num_pkgs = total_line:match("%d+")
--             -- Atualizando o texto do widget
--             widget.text = "   " .. num_pkgs .. " Pkgs | "
--         end
--     end)
-- end

-- -- Atualizando o widget a cada 3600 segundos
-- awful.widget.watch("sleep 3600", 3600, update_widget, pkg_widget)

-- return pkg_widget







-- Importando os módulos necessários
local awful = require("awful")
local wibox = require("wibox")

-- Criando o widget
local pkg_widget = wibox.widget.textbox()

-- Função para atualizar o widget e o tooltip
local function update_widget(widget)
    -- Executando o comando para verificar atualizações
    awful.spawn.easy_async("emerge -pvuND @world", function(stdout)
        -- Procurando a linha que contém o total de pacotes
        local total_line = stdout:match("(Total: %d+ packages)")
        if total_line then
            -- Extraindo o número de pacotes da linha
            local num_pkgs = total_line:match("%d+")
            -- Atualizando o texto do widget
            widget.text = "  " .. num_pkgs .. " Pkgs |"
        end

        -- Extraindo as informações das atualizações disponíveis
        local updates = stdout:match("Calculating dependencies... done!\n(.-)\n\nTotal: %d+ packages")
        if updates then
            -- Criando uma tabela para armazenar as atualizações
            local updates_table = {}
            -- Iterando sobre cada linha nas atualizações
            for line in updates:gmatch("[^\r\n]+") do
                -- Extraindo a primeira e segunda coluna de cada linha
                local pkg, ver = line:match("^([^ ]+) +([^ ]+)")
                if pkg and ver then
                    -- Adicionando a atualização à tabela
                    table.insert(updates_table, pkg .. " " .. ver)
                end
            end
            -- Criando o texto do tooltip
            local tooltip_text = table.concat(updates_table, "\n")
            -- Adicionando o tooltip ao widget
            awful.tooltip({
                objects = {widget},
                text = tooltip_text,
            })
        end
    end)
end

-- Atualizando o widget a cada 3600 segundos
awful.widget.watch("sleep 60", 60, update_widget, pkg_widget)

return pkg_widget
