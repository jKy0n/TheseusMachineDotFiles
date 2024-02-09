local gears = require("gears")

gears.debug = require("gears.debug")
gears.debug.usecolor = false  -- Defina como true se preferir logs coloridos

local naughty = require("naughty")

local log_path = os.getenv("HOME") .. "/home/jkyon/.dotfiles/.config/awesome/logs/debug.log"

gears.debug.print_error_log = true
gears.debug.print_warning_log = true
gears.debug.print_info_log = true
gears.debug.print_debug_log = true

gears.debug.file = log_path
gears.debug.print_callback = function(msg)
    naughty.notify({ text = msg })
end

gears.debug.init()
