
--

local awful = require("awful")
local beautiful = require("beautiful")

local rules = {
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).

--     -- All clients will match this rule.
--     { rule = { },
--       properties = { border_width = beautiful.border_width,
--                      border_color = beautiful.border_normal,
--                      focus = custom_focus_filter,
--              --      focus = awful.client.focus.filter,
--                      raise = true,
--                      keys = clientkeys,
--                      buttons = clientbuttons,
--                      screen = awful.screen.preferred,
--              --      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
--                      placement = awful.placement.centered,
--      }
--     },

        ---------------------------------------------
        -----------------  My Rules ----------------- 
        ---------------------------------------------
-- A
--
        { rule_any = { class = {"ark"} },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- B
--
-- C
--
-- D
--
        { rule = { class = "discord" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[3].tags[2] },},
       
        { rule = { class = "dolphin" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- E
--
-- F
--
        { rule = { class = "feh" },
        properties = { floating = true, name = "feh",
        width = 2800,     -- Defina o tamanho que deseja
        height = 1200,    -- Defina o tamanho que deseja
        x = 1600,         -- Posição x
        y = 100,          -- Posição y
        screen = 1  }},
-- G
--
        { rule_any = { class = {"gedit", "Gedit"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { class = "Google-chrome" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[2].tags[3] },},
        
        { rule = { class = "gnome-calculator" },
        properties = { floating = true,
        placement = awful.placement.centered },},
        
        { rule_any = { class = {"Gnome-disks", "gnome-disks"} },
        properties = { floating = true,
        placement = awful.placement.centered },},
        
        { rule = { class = "gpartedbin" },
        properties = { floating = true,
        placement = awful.placement.centered },},
        
        { rule = { class = "Gnome-screenshot" },
        properties = { floating = true,
        placement = awful.placement.centered },},        
-- H
--
        { rule_any = { class = {"Heroic Games Launcher", "heroic"} },
        properties = { floating = false,
        placement = awful.placement.centered },},
-- I
--
-- J
--
-- K
--
        { rule = { name = "KDE Connect" },
        properties = { floating = true,
        placement = awful.placement.centered },},    
-- L
--
        { rule = { name = "Lutris" },
        properties = { floating = true,
        placement = awful.placement.centered },},
    
        { rule = { class = "Lxappearance" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- M
--
        { rule_any = { class = {"mpv"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { name = "MuPDF" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- N
--      
        { rule = { class = "openrgb" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- O
--
-- P
--        
        { rule_any = { class = {"pavucontrol", "Pavucontrol"} },
        properties = { floating = false,
        tag = screen[3].tags[3]       },},
        
        { rule = { class = "PrismLauncher" },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule_any = { class = {"ProtonUp-Qt"} },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- Q
-- 
-- R
--      
        { rule = { class = "rambox" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[3].tags[2]       },},
-- S
--
        { rule = { class = "Spotify" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[3].tags[3]       },},

        { rule_any = { class = {"snappergui", "Snapper-gui"} },
        properties = { floating = true,
        placement = awful.placement.centered,},},

        { rule = { class = "steam" },
        properties = { floating = true,
        placement = awful.placement.centered },},

                { rule_any = { class = {" - News"} },
                properties = { floating = true,
                                placement = awful.placement.centered },},

                { rule_any = { name = {"Friends List"} },
                properties = { floating = false,
                            placement = awful.placement.left },},

                { rule_any = { name = {"steamwebhelper"} },
                properties = { floating = true,
                            placement = awful.placement.centered },},
-- T
--  
        { rule = { class = "Thunar" },
        properties = { floating = true, placement = awful.placement.centered },},
        
        { rule = { class = "thunderbird" },
        properties = { floating = false,
        placement = awful.placement.left,
        tag = screen[1].tags[3] },},
        
        { rule = { class = "Timeshift" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- U
--
-- V
--
        { rule_any = { class = {"virt-manager", "Virt-manager"} },
        properties = { floating = true,
        placement = awful.placement.centered,},},

        { rule_any = { class = {"code", "Code"} },     -- vsCode
        properties = { floating = true,
        placement = awful.placement.centered },},
-- W
--
-- X
--
-- Y
--
       { rule = { class = "yakuake" },
       properties = { floating = true, ontop = true, focus = true },
       callback = function(c)
           c:geometry({x=1450, y=25})
           c:connect_signal("unmanage", function() free_focus = true end)
       end },
-- Z
--          
                
    --         -- Floating clients.
    --         { rule_any = {
    --             instance = {
    --       "DTA",  -- Firefox addon DownThemAll.
    --       "copyq",  -- Includes session name in class.
    --       "pinentry",
    --     },
    --     class = {
    --       "Arandr",
    --       "Blueman-manager",
    --       "Gpick",
    --       "Kruler",
    --       "MessageWin",  -- kalarm.
    --       "Sxiv",
    --       "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
    --       "Wpa_gui",
    --       "veromix",
    --       "xtightvncviewer"},

    --     -- Note that the name property shown in xprop might be set slightly after creation of the client
    --     -- and the name shown there might not match defined rules here.
    --     name = {
    --       "Event Tester",  -- xev.
    --     },
    --     role = {
    --       "AlarmWindow",  -- Thunderbird's calendar.
    --       "ConfigManager",  -- Thunderbird's about:config.
    --       "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
    --     }
    --   }, properties = { floating = true }},

    -- -- Add titlebars to normal clients and dialogs
    -- { rule_any = {type = { "normal", "dialog" }
    --  },    properties = { titlebars_enabled = true },
    --        placement = awful.placement.centered
    -- },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },

}
return rules

-- }}}
