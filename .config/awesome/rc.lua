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


local lain = require "lain"
local mycpu = lain.widget.cpu()
local mymem = lain.widget.mem()
local mytemp = lain.widget.temp()


local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local todo_widget = require("awesome-wm-widgets.todo-widget.todo")
local weather_widget = require("awesome-wm-widgets.weather-widget.weather")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")

-- local vicious = require("vicious")



-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

    --- Notifications ---


--     naughty.config.defaults.ontop = true
--   --  naughty.config.defaults.icon_size = dpi(32)
--     naughty.config.defaults.timeout = 10
--     naughty.config.defaults.hover_timeout = 300
--   --  naughty.config.defaults.title = 'System Notification Title'
--    -- naughty.config.defaults.margin = dpi(16)
--     --naughty.config.defaults.border_width = 0
--     naughty.config.defaults.position = 'top_middle'
--     naughty.config.defaults.shape = function(cr, w, h)
--       gears.shape.rounded_rect(cr, w, h, dpi(6))
--     end




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

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/jkyon/.dotfiles/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
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
--    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier,
--    awful.layout.suit.corner.nw,
--    awful.layout.suit.floating,
--    awful.layout.suit.corner.ne,
--    awful.layout.suit.corner.sw,
--    awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
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


tbox_separator_pipe = wibox.widget.textbox (" | ")
tbox_separator_space = wibox.widget.textbox (" ")

tbox_gpu_label = wibox.widget.textbox ("GPU: ")
tbox_MHz_label = wibox.widget.textbox ("MHz")
tbox_separator_Celsius = wibox.widget.textbox ("ºC")




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

------------------------------------------------



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

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end


    ------------------  Tags  ------------------

awful.tag.add(" System ", {
--    icon = "/home/jkyon/.dotfiles/.config/awesome/icons/system.png",
    layout = awful.layout.suit.tile,
    screen = 1,
    selected = true
})

awful.tag.add(" Media ", {
--    icon = "/home/jkyon/.dotfiles/.config/awesome/icons/system.png",
    layout = awful.layout.suit.tile,
    screen = 1,
    selected = false
})

awful.tag.add(" Games ", {
--    icon = "/home/jkyon/.dotfiles/.config/awesome/icons/system.png",
    layout = awful.layout.suit.tile,
    screen = 1,
    selected = false
})

awful.tag.add(" Free =) ", {
--    icon = "/home/jkyon/.dotfiles/.config/awesome/icons/system.png",
    layout = awful.layout.suit.tile,
    screen = 1,
    selected = false
})

    ------------------ Second Monitor ------------------

awful.tag.add(" Search ", {
--    icon = "/home/jkyon/.dotfiles/.config/awesome/icons/system.png",
    layout = awful.layout.suit.tile,
    screen = 2,
    selected = true
})

awful.tag.add(" Media ", {
--    icon = "/home/jkyon/.dotfiles/.config/awesome/icons/system.png",
    layout = awful.layout.suit.tile,
    screen = 2,
    selected = false
})

awful.tag.add(" Free =) ", {
--    icon = "/home/jkyon/.dotfiles/.config/awesome/icons/system.png",
    layout = awful.layout.suit.tile,
    screen = 2,
    selected = false
})

        ------------------ Third Monitor ------------------

awful.tag.add(" Chat ", {
--    icon = "/home/jkyon/.dotfiles/.config/awesome/icons/system.png",
    layout = awful.layout.suit.tile,
    screen = 3,
    selected = false
})

awful.tag.add(" Music ", {
--    icon = "/home/jkyon/.dotfiles/.config/awesome/icons/system.png",
    layout = awful.layout.suit.tile,
    screen = 3,
    selected = false
})

awful.tag.add(" Monitor ", {
--    icon = "/home/jkyon/.dotfiles/.config/awesome/icons/system.png",
    layout = awful.layout.suit.tile,
    screen = 3,
    selected = true
})

        ---------------------------------------

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)


    -- Each screen has its own tag table.
--    awful.tag({ " 1 ", " 2 ", " 3 ", " 4 " }, s, awful.layout.layouts[1])


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

            tbox_separator_space,
            tbox_separator_space,
            tbox_separator_space,
            cpu.widget,
            tbox_separator_space,
            awful.widget.watch('bash -c "cat /sys/class/hwmon/hwmon4/temp1_input"', 1,
            function(widget, s) widget:set_text(tonumber(s)/1000) end),
            tbox_separator_Celsius,
            tbox_separator_pipe,
            mem.widget,
            tbox_separator_pipe,
            tbox_gpu_label,
            awful.widget.watch('bash -c "cat /sys/class/hwmon/hwmon5/freq1_input"', 1,
            function(widget, s) widget:set_text(tonumber(s)/1000000) end),
            tbox_MHz_label,
            tbox_separator_space,
            awful.widget.watch('bash -c "cat /sys/class/hwmon/hwmon5/temp1_input"', 1,
            function(widget, s) widget:set_text(tonumber(s)/1000) end),
            tbox_separator_Celsius,
            tbox_separator_space,
            todo_widget(),
            tbox_separator_space,
            volume_widget(),
            tbox_separator_space,
            tbox_separator_space,
            wibox.widget.systray(),
            tbox_separator_space,

           weather_widget({
              api_key='3adf0fe30d03af8c1d09c7dda3b196dd',
              coordinates = {24.012499355220648, -46.403999855263514},
              }),

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

            mytextclock,
            tbox_separator_space,

            logout_menu_widget{
                 font = 'sans 9',
                 onlock = function() awful.spawn.with_shell('i3lock-fancy') end
            },
            tbox_separator_space
        },
    }

end)
-- }}}




-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
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

    awful.key({ modkey, }, "p",
          function () awful.util.spawn("rofi -config ~/.config/rofi/config -show combi -combi-modi \"window,run\" -modi combi -theme ~/.config/rofi/config.rasi") end)
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



    awful.key({ }, "Print", function () awful.util.spawn("flameshot launcher") end),

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
             --      placement = awful.placement.no_overlap+awful.placement.no_offscreen
                     placement = awful.placement.centered
     }
    },


    { rule = { class = "yakuake" },
     properties = { floating = true, ontop = true, focus = true },
     callback = function(c)
         c:geometry({x=1450, y=25})
         c:connect_signal("unmanage", function() free_focus = true end)
     end },


    { rule_any = { name = {"google chrome", "google-chrome-stable", "Google Chrome"} },
      properties = { floating = false,
                    placement = awful.placement.centered,
                    tag = screen[2].tags[2]       },},


    { rule = { class = "Thunar" },
      properties = { floating = true, placement = awful.placement.centered },},

    { rule_any = { class = {"gnome-screenshot", "screenshot"} },
      properties = { floating = true, placement = awful.placement.centered },},


    { rule = { class = "discord" },
      properties = { floating = false,
                    placement = awful.placement.centered,
                    tag = screen[3].tags[1]       },},

    { rule = { name = "Rambox" },
      properties = { floating = false,
                    placement = awful.placement.centered,
                    tag = screen[3].tags[1]       },},

    { rule_any = { class = {"spotify", "Spotify"} },
      properties = { floating = false,
                    placement = awful.placement.centered,
                    tag = screen[3].tags[2]       },},


    { rule = { name = "Steam" },
      properties = { floating = false,
                    placement = awful.placement.centered,
                    tag = screen[1].tags[3]       },},

    { rule_any = { class = {"Friends List"} },
      properties = { floating = true,
                    placement = awful.placement.centered,
                    tag = screen[1].tags[3]       },},

    { rule_any = { class = {" - News"} },
      properties = { floating = true,
                    placement = awful.placement.centered,
                    tag = screen[1].tags[3]       },},

    { rule = { name = "Prism Launcher" },
      properties = { floating = true,
                    placement = awful.placement.centered,
                    tag = screen[1].tags[3]       },},

    -- { rule_any = { class = {"prismlauncher", "Prism Launcher"} },
    --   properties = { floating = true,
    --                 placement = awful.placement.centered,
    --                 tag = screen[1].tags[3]       },},

    { rule_any = { class = {"Heroic Games Launcher", "heroic"} },
      properties = { floating = false,
                    placement = awful.placement.centered,
                    tag = screen[1].tags[3]       },},

    { rule = { name = "Lutris" },
      properties = { floating = true,
                    placement = awful.placement.centered,
                    tag = screen[1].tags[3]       },},

    { rule = { class = "Timeshift" },
      properties = { floating = true,
                    placement = awful.placement.centered },},


    { rule = { name = "MuPDF" },
      properties = { floating = true,
                    placement = awful.placement.centered },},

    { rule = { name = "Customize Look and Feel" },
      properties = { floating = true,
                    placement = awful.placement.centered },},

    { rule = { name = "KDE Connect" },
      properties = { floating = true,
                    placement = awful.placement.centered },},

    { rule = { name = "OpenRGB" },
      properties = { floating = true,
                    placement = awful.placement.centered },},



    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
     },    properties = { titlebars_enabled = true },
           placement = awful.placement.centered
    },

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

    client.connect_signal("manage", function(c)
    c.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 10)
    end
end)

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


--     awful.titlebar(c) : setup {
--         { -- Left
--         awful.titlebar.widget.closebutton    (c),
--         awful.titlebar.widget.maximizedbutton(c),
--         awful.titlebar.widget.floatingbutton (c),
-- --            awful.titlebar.widget.stickybutton   (c),
-- --            awful.titlebar.widget.ontopbutton    (c),
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

-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus c.opacity = 1 end)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal c.opacity = 0.95 end)

-- jKyon Adds




beautiful.useless_gap = 2
beautiful.tasklist_shape_focus = gears.shape.rounded_rect
beautiful.taglist_shape_focus = gears.shape.rounded_rect
beautiful.notification_shape = gears.shape.rounded_rect


gears.wallpaper.maximized("/home/jkyon/Pictures/Wallpapers/LinuxWallpapers/multi-monitor-wallpapers.jpg", s)

awful.spawn.with_shell("picom --daemon --config $HOME/.config/picom/picom.conf")
awful.spawn.with_shell("yakuake")
