--
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local common = require("awful.widget.common")

local free_focus = true
local function custom_focus_filter(c) return free_focus and awful.client.focus.filter(c) end


local rules = require("jkyon-modules.rules") -- Adcciona arquivo de regras rules.lua

local rotate = require("screenrotation")

local lain = require "lain"
local mycpu = lain.widget.cpu()
local mymem = lain.widget.mem()
local mytemp = lain.widget.temp()

local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")


local volume_widget = require('awesome-wm-widgets.pactl-widget.volume')
--local myvolume = volume_widget()
-- local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local todo_widget = require("awesome-wm-widgets.todo-widget.todo")
local weather_widget = require("awesome-wm-widgets.weather-widget.weather")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")

local internet_widget = require("jkyon-widgets.internet_widget")
-- local gentoo_update_checker = require("jkyon-widgets.gentoo_update_checker")


-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
------------------------------- Error handling ------------------------------

-- Configurar o tamanho padrão das notificações
naughty.config.defaults['icon_size'] = 300


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end) 
end
-- }}}

------------------------------- Error handling ------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/jkyon/.dotfiles/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.magnifier,
--    awful.layout.suit.corner.nw,
--    awful.layout.suit.floating,
    awful.layout.suit.corner.ne,
--    awful.layout.suit.corner.sw,
--    awful.layout.suit.corner.se,
--    awful.layout.suit.max.fullscreen,
    awful.layout.suit.max,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
--   { "restart", awesome.restart },
--   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Apps" },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
-- mytextclock = wibox.widget.textclock(" %A, %d %B, %H:%M ", 60)
mytextclock = wibox.widget.textclock()


-------------------- Widgets --------------------


tbox_separator_space = wibox.widget.textbox (" ")
-- tbox_separator_pipe = wibox.widget.textbox (" | ")
-- tbox_separator_dash = wibox.widget.textbox (" - ")


local cpu = lain.widget.cpu {
    settings = function()
        widget:set_markup("CPU " .. cpu_now.usage .. "%")
    end
}

local mem = lain.widget.mem {
    settings = function()
        widget:set_markup("RAM " .. mem_now.perc .. "%")
    end
}

local temp = lain.widget.temp({
    settings = function()
        widget:set_markup("Temp " .. coretemp_now .. "°C ")
    end
})


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local cw = calendar_widget({
    theme = 'naughty',
    placement = 'top_right',
    start_sunday = true,
    radius = 8,
--  with customized next/previous (see table above)
    previous_month_button = 1,
    next_month_button = 3,
})
mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
    end)

---------------------------------------------------------------------
--------------------  Custom Notification Center  -------------------

-- This awful.wibar will be placed at the bottom and contain the notifications.
-- local notif_wb = awful.wibar {
--     position = "bottom",
--     height   = 48,
--     visible  = #naughty.active > 0,
-- }

-- notif_wb:setup {
--     nil,
--     {
--         base_layout = wibox.widget {
--             spacing_widget = wibox.widget {
--                 orientation = "vertical",
--                 span_ratio  = 0.5,
--                 widget      = wibox.widget.separator,
--             },
--             forced_height = 30,
--             spacing       = 3,
--             layout        = wibox.layout.flex.horizontal
--         },
--         widget_template = {
--             {
--                 naughty.widget.icon,
--                 {
--                     naughty.widget.title,
--                     naughty.widget.message,
--                     {
--                         layout = wibox.widget {
--                             -- Adding the wibox.widget allows to share a
--                             -- single instance for all spacers.
--                             spacing_widget = wibox.widget {
--                                 orientation = "vertical",
--                                 span_ratio  = 0.9,
--                                 widget      = wibox.widget.separator,
--                             },
--                             spacing = 3,
--                             layout  = wibox.layout.flex.horizontal
--                         },
--                         widget = naughty.list.widgets,
--                     },
--                     layout = wibox.layout.align.vertical
--                 },
--                 spacing = 10,
--                 fill_space = true,
--                 layout  = wibox.layout.fixed.horizontal
--             },
--             margins = 5,
--             widget  = wibox.container.margin
--         },
--         widget = naughty.list.notifications,
--     },
--     -- Add a button to dismiss all notifications, because why not.
--     {
--         {
--             text   = "Dismiss all",
--             halign = "center",
--             valign = "center",
--             widget = wibox.widget.textbox
--         },
--         buttons = gears.table.join(
--             awful.button({ }, 1, function() naughty.destroy_all_notifications() end)
--         ),
--         forced_width       = 75,
--         shape              = gears.shape.rounded_bar,
--         shape_border_width = 1,
--         shape_border_color = beautiful.bg_highlight,
--         widget = wibox.container.background
--     },
--     layout = wibox.layout.align.horizontal
-- }

-- -- We don't want to have that bar all the time, only when there is content.
-- naughty.connect_signal("property::active", function()
--     notif_wb.visible = #naughty.active > 0
-- end)

---------------------------------------------------------------------
--------------------  Custom Notification Center  -------------------


    -- ruled.notification.connect_signal('request::rules', function()
    --     ruled.notification.append_rule {
    --         rule = { },
    --         properties = {
    --             screen = awful.screen.preferred,
    --             implicit_timeout = 5,
    --             position = "top_center", -- Defina como "top_center"
    --         }
    --     }
    -- end)


--------------------  Notification Custom Preset  -------------------
---------------------------------------------------------------------
-------------------  Tags Manipulation Functions  -------------------

local function add_tag()
    awful.tag.add(" NewTag ", {
        screen = awful.screen.focused(),
        layout = awful.layout.suit.tile,
        volatile = true
    }):view_only()
end 

local function delete_tag()
    local t = awful.screen.focused().selected_tag
    if not t then return end
    t:delete()
end

local function rename_tag()
    awful.prompt.run {
        prompt       = "New tag name: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end

            local t = awful.screen.focused().selected_tag
            if t then
                t.name = new_name
            end
        end
    }
end

local function move_to_new_tag()
    local c = client.focus
    if not c then return end

    local t = awful.tag.add(c.class,{screen= c.screen, layout = awful.layout.suit.tile, volatile = true })
    c:tags({t})
    t:view_only()
end

-------------------  Tags Manipulation Functions  -------------------


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
------------------------------ Tags Organization ----------------------------


awful.tag.add(" emerge (1) ", {
    layout = awful.layout.suit.tile.left,
    screen = 1,
    selected = false
})

awful.tag.add(" Code (2) ", {
    layout = awful.layout.suit.tile,
    screen = 1,
    selected = true
})

awful.tag.add(" Mail (3) ", {
    layout = awful.layout.suit.tile,
    screen = 1,
    selected = false
})

awful.tag.add(" etc (4) ", {
    layout = awful.layout.suit.tile.left,
    screen = 1,
    selected = false
})

-- awful.tag.add(" Games (X) ", {
--     layout = awful.layout.suit.tile.left,
--     screen = 1,
--     selected = false
-- })

-- awful.tag.add(" Krita (6) ", {
--     layout = awful.layout.suit.tile.left,
--     screen = 1,
--     selected = false
-- })

-- awful.tag.add(" VirtManager (7) ", {
--     layout = awful.layout.suit.tile.left,
--     screen = 1,
--     selected = false
-- })

-- awful.tag.add(" Free =) ", {
--     layout = awful.layout.suit.tile,
--     screen = 1,
--     selected = false
-- })

    ------------------ Second Monitor ------------------

awful.tag.add(" Monitor (1) ", {
    layout = awful.layout.suit.max,
    screen = 2,
    selected = false
})

awful.tag.add(" Search (2) ", {
    layout = awful.layout.suit.tile,
    screen = 2,
    selected = true
})

awful.tag.add(" Media (3) ", {
    layout = awful.layout.suit.max,
    screen = 2,
    selected = false
})

-- awful.tag.add(" Free =) ", {
--     layout = awful.layout.suit.tile,
--     screen = 2,
--     selected = false,
-- })

        ------------------ Third Monitor ------------------

awful.tag.add(" Monitor (1) ", {
    layout = awful.layout.suit.tile.bottom,
    screen = 3,
    selected = true
})

awful.tag.add(" Chat (2) ", {    
    layout = awful.layout.suit.max,
    screen = 3,
    selected = false
})

awful.tag.add(" Sound (3) ", {
    layout = awful.layout.suit.tile,
    screen = 3,
    selected = false
})

-- awful.tag.add(" Mixer (4) ", {
--     layout = awful.layout.suit.tile,
--     screen = 3,
--     selected = false
-- })

-- awful.tag.add(" Free =) ", {
--     layout = awful.layout.suit.tile,
--     screen = 3,
--     selected = false
-- })


------------------------------ Tags Organization ----------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


        awful.screen.connect_for_each_screen(function(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style   = {
             shape  = gears.shape.rounded_bar,
        },
   }



    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, opacity = 0.8, border_width = 3, shape = gears.shape.rounded_rect 	 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
--            mylauncher,
            tbox_separator_space,
            s.mylayoutbox,
            tbox_separator_space,
            tbox_separator_space,
            s.mytaglist,
            tbox_separator_space,
            s.mypromptbox,
            tbox_separator_space,

        },

        s.mytasklist, -- Middle widget

        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
--            mykeyboardlayout,

            internet_widget,

                    tbox_separator_space,

            -- wibox.widget.textbox('  '),


            --gentoo_update_checker,
            awful.widget.watch('bash -c "nice -n 19 sh /home/jkyon/ShellScript/dwmBlocksUpdates"', 3600),


            -- jkyon_gentooUpdatesWidget = awful.widget.watch("bash -c 'sh /home/jkyon/ShellScript/dwmBlocksUpdates' " .. atualizarGentooUpdatesWidget_complemento .. "", 600, atualizarGentooUpdatesWidget),
            -- jkyon_gentooUpdatesWidget = awful.widget.watch("bash -c 'sh /home/jkyon/ShellScript/dwmBlocksUpdates'", 600, atualizarGentooUpdatesWidget),
           
                    -- tbox_separator_space,
------------------------------------------------------------------------------------------------            
            -- wibox.widget.textbox(' | '),
------------------------------------------------------------------------------------------------
                    tbox_separator_space,
          
            wibox.widget.textbox('   '),
            wibox.widget.textbox('CPU: '),
            -- cpu.widget,
            awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/dwmBlocksCpuUsage"', 1),
                    tbox_separator_space,
            wibox.widget.textbox('  '),
            awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/dwmBlocksCpuTemp"', 1),
                    tbox_separator_space,
------------------------------------------------------------------------------------------------            
            wibox.widget.textbox(' | '),
------------------------------------------------------------------------------------------------
                    tbox_separator_space,
           
            cpu_widget(),
           
                    tbox_separator_space,
------------------------------------------------------------------------------------------------            
            wibox.widget.textbox(' | '),
------------------------------------------------------------------------------------------------
            wibox.widget.textbox('   '),  --  
            mem.widget,
            ram_widget({ color_used = '#cba6f7', color_buf = '#444444' }),
------------------------------------------------------------------------------------------------            
            wibox.widget.textbox(' | '),
------------------------------------------------------------------------------------------------
            
            wibox.widget.textbox(' 󰢮 '),  --  

           wibox.widget.textbox(' GPU: '),
           awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0usage-fast.sh"', 1),
                 tbox_separator_space,
           awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0freq.sh"', 1),
                 tbox_separator_space,
           wibox.widget.textbox('  '),
           awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu0temp.sh"', 1),
            
--            tbox_separator_space,
--            wibox.widget.textbox(' | '),
--            tbox_separator_space,

--          wibox.widget.textbox('GPU1: '),
--          awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu1freq.sh"', 1),
--                  tbox_separator_space,
--          wibox.widget.textbox('  '),
--          awful.widget.watch('bash -c "sh ~/ShellScript/awesomeWidget-gpu1temp.sh"', 1),
            
                    tbox_separator_space,
------------------------------------------------------------------------------------------------            
            wibox.widget.textbox(' | '),
------------------------------------------------------------------------------------------------
                    tbox_separator_space,

            volume_widget({ 
                widget_type = 'arc',
                thickness   = 2 ,
                step        = 5 ,
                mixer_cmd   = 'pavucontrol',
                device      = '@DEFAULT_SINK@',
                tooltip     = false
                }),
            
                    tbox_separator_space,
            
            todo_widget(),
            
                    tbox_separator_space,
                    tbox_separator_space,
            
            wibox.widget.systray(),
            
                    tbox_separator_space,

            -- weather_widget({
            --   api_key='3adf0fe30d03af8c1d09c7dda3b196dd',
            --   coordinates = {24.0124, -46.4039},
            --   }),

            --  weather_curl_widget({
            --     api_key = '3adf0fe30d03af8c1d09c7dda3b196dd',
            --     coordinates = {24.012499355220648, -46.403999855263514},
            --     time_format_12h = true,
            --     units = 'imperial',
            --     both_units_widget = true,
            --     font_name = 'Carter One',
            --     icons = 'VitalyGorbachev',
            --     icons_extension = '.svg',
            --     show_hourly_forecast = true,
            --     show_daily_forecast = true,
            -- }),
            -- weather_widget({ api_key = '3adf0fe30d03af8c1d09c7dda3b196dd', coordinates = {45.5017, -73.5673}, }),
            mytextclock,

                    tbox_separator_space,

            logout_menu_widget{
                -- font = 'Noto Sans semibold 9',
                 font = 'MesloLGS Nerd Font Bold 10',
                 onlogout   =  function() awesome.quit() end,
                --  onlock     =  function() awful.spawn.with_shell('xscreensaver-command -lock') end,
                 onsuspend  =  function() awful.spawn.with_shell("loginctl suspend") end,
                 onreboot   =  function() awful.spawn.with_shell("loginctl reboot") end,
                 onpoweroff =  function() awful.spawn.with_shell("loginctl poweroff") end,
            },
                    tbox_separator_space
        },
    }

-- }}}
end)

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

    -- -- alt + tab
    -- awful.key({ "Mod1", }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end),

    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),

    -- Menubar
    -- awful.key({ modkey }, "p",
    --            function()
    --                 menubar.show()
    --            end, {
    --                 description = "show the menubar",
    --                 group = "launcher"
    --       })

    -- awful.key({ modkey}, "p", function () awful.util.spawn_with_shell("~/.config/dmenu") end)

    -- awful.key({ modkey, }, "p",
    --     function () awful.util.spawn("rofi  -config /home/jkyon/.dotfiles/.config/rofi/config.rasi \
    --                                         -icon-theme \"Papirus\"  \
    --                                         -show-icons") 
    --         end),

    awful.key({ modkey, }, "p",
        --   function () awful.util.spawn("rofi -config ~/.config/rofi/config -show combi -combi-modi \"window,run\" -modi combi -icon-theme \"Papirus\" -show-icons -theme ~/.config/rofi/config.rasi") end),
        function () awful.util.spawn("rofi  -config /home/jkyon/.dotfiles/.config/rofi.jkyon/config.rasi \
                                            -show drun \
                                            -icon-theme \"Papirus\"  \
                                            -show-icons -theme /home/jkyon/.dotfiles/.config/rofi.jkyon/theme.rasi") 
            end),


    -- alt + tab
    awful.key({ "Mod1", }, "Tab",
        function () awful.util.spawn("rofi  -config /home/jkyon/.dotfiles/.config/rofi.jkyon/config.rasi \
                                            -show window \
                                            -window-format \"{t}\" \
                                            -kb-row-down 'Alt+Tab,Alt+Down,Down' \
                                            -kb-row-up 'Alt+ISO_Left_Tab,Alt+Up,Up' \
                                            -kb-accept-entry '!Alt-Tab,!Alt+Down,!Alt+ISO_Left_Tab,!Alt+Up,Return' \
                                            -me-select-entry 'MouseSecondary' \
                                            -me-accept-entry 'MousePrimary' \
                                            -modi combi -icon-theme \"Papirus\" \
                                            -show-icons -theme /home/jkyon/.dotfiles/.config/rofi.jkyon/theme-tab.rasi") 
            end),


---------------------  Tags Manipulation keybinds  ---------------------
------------------------------------------------------------------------

    awful.key({ modkey,           }, "a", add_tag,
        {description = "add a tag", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "a", delete_tag,
        {description = "delete the current tag", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "r", rename_tag,
        {description = "rename the current tag", group = "tag"}),
    awful.key({ modkey, "Control"   }, "a", move_to_new_tag,
        {description = "add a tag with the focused client", group = "tag"})

------------------------------------------------------------------------
------------------------------------------------------------------------

--   awful.key({ modkey }, "Up", function() rotate("normal") end,
--     {description = "Normal tag rotation", group = "tag"}),
--   awful.key({ modkey }, "Down", function() rotate("inverted") end,
--     {description = "Inverted tag rotation", group = "tag"}),
--   awful.key({ modkey }, "Left", function() rotate("left") end,
--     {description = "Counter-clockwise tag rotation", group = "tag"}),
--   awful.key({ modkey }, "Right", function() rotate("right") end,
--     {description = "Clockwise tag rotation", group = "tag"})

------------------------------------------------------------------------ 
------------------------------------------------------------------------     
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),


        awful.key({}, "XF86AudioRaiseVolume", function() volume_widget:inc(5) end),
        awful.key({}, "XF86AudioLowerVolume", function() volume_widget:dec(5) end),
        awful.key({}, "XF86AudioMute", function() volume_widget:toggle() end),

        awful.key({}, "XF86AudioPrev", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous") end),
        awful.key({}, "XF86AudioNext", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next") end),
        awful.key({}, "XF86AudioPlay", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause") end),
        awful.key({}, "XF86AudioStop", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause") end),


    awful.key({ }, "Print", function () awful.util.spawn("gnome-screenshot --interactive") end),

    awful.key({ modkey, "Control" }, "Escape", function () awful.util.spawn("loginctl suspend") end),
    

    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end



clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}


awful.rules.rules = rules

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = custom_focus_filter,
             --      focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
             --      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     placement = awful.placement.centered,
     }
    },



        ---------------------------------------------
        -----------------  My Rules ----------------- 
        ---------------------------------------------
-- A
--
        { rule = { class = "Alacritty" },
        properties = { titlebars_enabled = false } },

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

-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end


---------------------------------------------------------------
---------------------  Rounded corners??  ---------------------

--     client.connect_signal("manage", function(c)
--     c.shape = function(cr, w, h)
--         gears.shape.rounded_rect(cr, w, h, 10)
--     end
-- end)

---------------------  Rounded corners??  ---------------------
---------------------------------------------------------------


    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )


--      Aqui eu tirei o frame (moldura) das janelas 
--
--     awful.titlebar(c) : setup {
--         { -- Left
--         awful.titlebar.widget.closebutton    (c),
--         awful.titlebar.widget.maximizedbutton(c),
--         awful.titlebar.widget.floatingbutton (c),
--         awful.titlebar.widget.stickybutton   (c),
--         awful.titlebar.widget.ontopbutton    (c),
--
--         layout = wibox.layout.fixed.horizontal(),
--         },
--         { -- Middle
--             { -- Title
--                 align  = "center",
--                 widget = awful.titlebar.widget.titlewidget(c)
--             },
--             buttons = buttons,
--             layout  = wibox.layout.flex.horizontal
--         },
--         { -- Right
--             awful.titlebar.widget.iconwidget(c),
--             buttons = buttons,
--             layout  = wibox.layout.fixed.horizontal
--         },
--         layout = wibox.layout.align.horizontal
--     }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end) 
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)



-- jKyon Adds
--

-- Notifications adjustments
-- beautiful.notification_font = "sans 12"  -- Altere o tamanho conforme desejado
beautiful.notification_font = "MesloLGS Nerd Font 12"



-- Run garbage collector regularly to prevent memory leaks
gears.timer {
    timeout = 30,
    autostart = true,
    callback = function() collectgarbage() end
}


-- beautiful.wallpaper = "/home/jkyon/Pictures/Wallpapers/LinuxWallpapers/multi-monitor-wallpapers.jpg"


awful.spawn.with_shell("sh /home/jkyon/.dotfiles/.config/awesome/AwesomeWMstartupApps.sh")



-- timed = rubato.timed {
--     intro = 0.1,
--     duration = 0.3
-- }
-- timed.target = 1
