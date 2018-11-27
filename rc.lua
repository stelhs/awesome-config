-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
require('helpers')

-- User libraries
local vicious = require("vicious") -- ./vicious

-- Load Debian menu entries
require("debian.menu")

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
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/usr/share/awesome/themes/zhongguo/zhongguo.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
--    awful.layout.suit.floating,
    awful.layout.suit.tile,
--    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
--    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "console", terminal },
                                    { "calc", "speedcrunch" },
                                    { "double commander", "doublecmd" },
                                    { "google-chrome", "google-chrome-stable" },
                                    { "subl", "subl" },
                                    { "pinta", "pinta" },
                                    { "splan", "wine \"/home/stelhs/.wine/drive_c/Program Files (x86)/Splan70/splan70.exe\"" },
                                    { "diptrace", "wine \"/home/stelhs/.wine/drive_c/Program Files/DipTrace_3_0/Launcher.exe\"" },
                                    { "eclipse", "/opt/eclipse/eclipse" },
                            { "eclipse-php", "/opt/eclipse-php/eclipse" },
                                  }
                        })


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


require('wibox_line')


-- {{{ Mouse bindingsO
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

audio_volume = 50
mute = 0;

function audio_volume_set(audio_volume)
  cmd = "amixer -q set Master " .. audio_volume .. "%"
   awful.util.spawn(cmd)
  awful.util.spawn("amixer -q set Speaker 100%")
  awful.util.spawn("amixer -q set 'Bass Speaker' 100%")
  awful.util.spawn("amixer -q set PCM 100%")
  awful.util.spawn("amixer -q set 'Mic Boost' 100%")
end

function mute_unmute(mute)
  if mute == 0 then
    cmd = "amixer -q set Master unmute"
    awful.util.spawn("amixer -q set Speaker unmute")
    awful.util.spawn("amixer -q set 'Bass Speaker' unmute")
  else 
    cmd = "amixer -q set Master mute"
  end
  awful.util.spawn(cmd)
end

function on_click_audio_volume_lower()
  audio_volume = audio_volume - 5
  if audio_volume < 0 then
    audio_volume = 0
  end
  audio_volume_set(audio_volume)
  naughty.notify({ title = "volume down",
                   timeout = 1,
                   text = "volume: " ..  audio_volume .. "%"})
end
  
function on_click_audio_volume_raise()
  audio_volume = audio_volume + 5
  if audio_volume > 100 then
    audio_volume = 100
  end
  audio_volume_set(audio_volume)
  naughty.notify({ title = "volume up",
                   timeout = 1,
                   text = "volume: " ..  audio_volume .. "%"})
end

function on_click_audio_volume_mute()
  if mute == 1 then
    mute = 0
    naughty.notify({ title = "UNMUTE",
                     timeout = 1})
  else
    mute = 1
    naughty.notify({ title = "MUTE",
                     timeout = 1})
  end
  mute_unmute(mute)
end

-- {{{ Key bindings
globalkeys = awful.util.table.join(
--    awful.key({ modkey,   4        }, "Left",   awful.tag.viewprev       ),
--    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "w",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "q",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
--    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "w", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "q", function () awful.client.swap.byidx( -1)    end),
--    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
--    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "e", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "e", function () awful.util.spawn("doublecmd") end),
    awful.key({ modkey, "Shift"   }, "c", function () awful.util.spawn(terminal .. " -e 'python3 -i /home/stelhs/.calc.py'") end),
    awful.key({ modkey, "Shift"   }, "n", function () awful.util.spawn(terminal .. " -e 'ping google.com'") end),
    awful.key({ modkey, "Shift"   }, "s", function () awful.util.spawn("gnome-screenshot -i") end),
    awful.key({ modkey, "Shift"   }, "d", function () awful.util.spawn("/home/stelhs/.config/awesome/screenshot.sh") end),
    awful.key({ modkey, "Shift"   }, "v", function () awful.util.spawn("mono /home/stelhs/tools/smath/SMathStudio_Desktop.exe") end),
--    awful.key({ modkey, "Shift"   }, "m", function () awful.util.spawn("/bin/bash -c 'LANG=ru_RU.UTF8 wine \"/home/stelhs/.wine/drive_c/Program Files (x86)/Splan70/splan70.exe\"'") end),
    awful.key({ modkey, "Shift"   }, "m", function () awful.util.spawn("/bin/bash -c '/home/stelhs/projects/software/my/electro/electro.py'") end),
    awful.key({ modkey,           }, "h", function () awful.util.spawn("/home/stelhs/.config/awesome/display_switcher.sh") end),
    awful.key({ modkey,           }, "F6", function () awful.util.spawn("synclient TouchpadOff=1") end),
    awful.key({ modkey, "Shift"   }, "F6", function () awful.util.spawn("synclient TouchpadOff=0") end),
    awful.key({ modkey,           }, "F2", function () awful.util.spawn("xcalib -i -a") end),
    awful.key({ modkey,           }, "F3", function () awful.util.spawn("vlc /home/stelhs/Music/buzzer.ogg.m3u") end),
    awful.key({ modkey, "Shift"   }, "f", function () awful.util.spawn("google-chrome") end),
    awful.key({ modkey,           }, ",", function () awful.util.spawn("xbacklight -dec 10") end),
    awful.key({ modkey,           }, ".", function () awful.util.spawn("xbacklight -inc 10") end),
    awful.key({ modkey, "Shift"   }, "a", function () wallpapers_update() end),

    awful.key({ modkey, "Control" }, "r", awesome.restart),
--    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ modkey, "Shift"   }, "b", function () awful.util.spawn("subl -n /home/stelhs/docs/subl-notes/notes.txt") end),

    awful.key({}, "XF86AudioLowerVolume", function () on_click_audio_volume_lower() end),
    awful.key({}, "XF86AudioRaiseVolume", function () on_click_audio_volume_raise() end),
    awful.key({}, "XF86AudioMute", function () on_click_audio_volume_mute() end),
    awful.key({ modkey, "Control" }, "z", function () on_click_audio_volume_lower() end),
    awful.key({ modkey, "Control" }, "x", function () on_click_audio_volume_mute() end),
    awful.key({ modkey, "Control" }, "c", function () on_click_audio_volume_raise() end),

    awful.key({ }, "XF86AudioPrev", function () awful.util.spawn("qmmp --previous") end),
    awful.key({ }, "XF86AudioNext", function () awful.util.spawn("qmmp --next") end),
    awful.key({ }, "XF86AudioPlay", function () awful.util.spawn("qmmp -t") end),
    awful.key({ "Control" }, "XF86AudioPrev", function () awful.util.spawn("qmmp --seek-bwd 5") end),
    awful.key({ "Control" }, "XF86AudioNext", function () awful.util.spawn("qmmp --seek-fwd 5") end),
    awful.key({ modkey, "Control" }, "q", function () awful.util.spawn("qmmp --previous") end),
    awful.key({ modkey, "Control" }, "w", function () awful.util.spawn("qmmp -t") end),
    awful.key({ modkey, "Control" }, "e", function () awful.util.spawn("qmmp --next") end),
    awful.key({ modkey, "Control" }, "a", function () awful.util.spawn("qmmp --seek-bwd 5") end),
    awful.key({ modkey, "Control" }, "d", function () awful.util.spawn("qmmp --seek-fwd 5") end),

    awful.key({ modkey,           }, "Left",  function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey,           }, "Right", function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "Up",    function () awful.client.incwfact(0.05)  end),
    awful.key({ modkey,           }, "Down",  function () awful.client.incwfact(-0.05)   end),
    awful.key({ modkey, altkey    }, "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end),
    awful.key({ modkey, altkey    }, "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),
    awful.key({ modkey, altkey    }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
    awful.key({ modkey, altkey    }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
    awful.key({ modkey, altkey    }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
    awful.key({ modkey, altkey    }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),    
    awful.key({ modkey,           }, "a",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey,           }, "s",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey,           }, "t",      awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "F1",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

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
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "ROX-Filer" },   properties = { floating = true } },
    { rule = { class = "Plugin-container" },   properties = { floating = true, border_width = 0 } },
    { rule = { class = "Chromium-browser" },   properties = { floating = false } },
    { rule = { class = "Google-chrome" },   properties = { floating = false } },
--    { rule = { class = "Firefox" },   properties = { floating = false, tag = tags[1][2] } },
    { rule = { class = "Skype" },   properties = { floating = false, tag = tags[1][1] } },
    { rule = { class = "Qmmp" },   properties = { floating = true, tag = tags[1][6] } },
    { rule = { class = "Firefox", instance = "startup" }, properties = { floating = false, tag = tags[1][2]} },s
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    elseif not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count change
        awful.placement.no_offscreen(c)
    end

    c.minimized = false
    c.hidden = false
    c.skip_taskbar = true

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


require('wallpapers')
require('autorun')
