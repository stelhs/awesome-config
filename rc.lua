-- {{{ License
--
-- Awesome configuration, using awesome 3.4.10 on Ubuntu 11.10
--   * Tony N <tony@git-pull.com>
--
-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- based off Adrian C. <anrxc@sysphere.org>'s rc.lua
-- }}}


-- {{{ Libraries
require("awful")
require("awful.rules")
require("awful.autofocus")
require("naughty")
-- User libraries
require("vicious") -- ./vicious
require("helpers") -- helpers.lua
-- }}}

-- Load Debian menu entries
require("debian.menu")



-- {{{ Configuration
altkey = "Mod1"
modkey = "Mod4" -- your windows/apple key

terminal = 'gnome-terminal'
editor = "subl"
editor_cmd = terminal .. " -e " .. editor


-- {{{ Variable definitions
local home   = os.getenv("HOME")
exec   = awful.util.spawn
sexec  = awful.util.spawn_with_shell

-- Beautiful theme
beautiful.init(awful.util.getdir("config") .. "/themes/zhongguo/zhongguo.lua")

-- Window management layouts
layouts = {
  awful.layout.suit.tile,
--  awful.layout.suit.fair,
--  awful.layout.suit.fair.horizontal,
  awful.layout.suit.tile.bottom
--  awful.layout.suit.spiral.dwindle,
  --awful.layout.suit.spiral,
  --awful.layout.suit.tile.top,
  --awful.layout.suit.max,
  --awful.layout.suit.magnifier,
  --awful.layout.suit.floating
}
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
                                    { "firefox", "firefox" },
                                    { "subl", "subl" },
                                    { "pinta", "pinta" },
                                    { "splan", "wine \"/home/stelhs/.wine/drive_c/Program Files (x86)/Splan70/splan70.exe\"" },
                                    { "diptrace", "wine \"/home/stelhs/.wine/drive_c/Program Files (x86)/DipTrace/Launcher.exe\"" },
                                    { "eclipse", "/opt/eclipse/eclipse" }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

--{{{ Tags
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

require('wibox_line')

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Client bindings
clientbuttons = awful.util.table.join(
    awful.button({ },        1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)
-- }}}


-- {{{ Key bindings
globalkeys = awful.util.table.join(
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

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "w", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "q", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "e", function () exec(terminal) end),
    awful.key({ modkey, "Shift"   }, "e", function () exec("doublecmd") end),
    awful.key({ modkey, "Shift"   }, "c", function () exec(terminal .. " -e 'python -i /home/stelhs/.calc.py'") end),
    awful.key({ modkey, "Shift"   }, "n", function () exec(terminal .. " -e 'ping google.com'") end),
    awful.key({ modkey, "Shift"   }, "f", function () exec("firefox") end),
--    awful.key({ modkey, "Shift"   }, "v", function () exec(terminal .. " -e 'vim /home/stelhs/docs/vim-notes/v.txt'") end),
    awful.key({ modkey, "Shift"   }, "v", function () exec("mono /home/stelhs/tools/smath/SMathStudio_Desktop.exe") end),
    awful.key({ modkey, "Shift"   }, "b", function () exec("subl -n /home/stelhs/docs/subl-notes/notes.txt") end),
    awful.key({ modkey,           }, "F6", function () exec("synclient TouchpadOff=1") end),
    awful.key({ modkey, "Shift"   }, "F6", function () exec("synclient TouchpadOff=0") end),
    awful.key({ modkey,           }, ",", function () exec("xbacklight -dec 10") end),
    awful.key({ modkey,           }, ".", function () exec("xbacklight -inc 10") end),

    -- Enable russian key
    awful.key({ },
              "Alt_R",
              function ()
  --                exec("setxkbmap -option")
--                  exec("setxkbmap -layout 'us,ru' -option grp:shift_caps_switch,grp_led:caps")
                  exec("qdbus ru.gentoo.KbddService /ru/gentoo/KbddService  ru.gentoo.kbdd.set_layout 1") 
              end),
    awful.key({ },
             "Shift_R",
             function () 
                  exec("setxkbmap -option")
                  exec("setxkbmap -layout 'us,ru' -option grp:shift_caps_switch,grp_led:caps")
             end),
    -- Enable english key
--    awful.key({ }, "ISO_First_Group",  function () exec("qdbus ru.gentoo.KbddService /ru/gentoo/KbddService  ru.gentoo.kbdd.set_layout 2") end),

--    awful.key({ modkey, "Control" }, "r", awesome.restart),
--    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

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
    awful.key({ modkey, "Shift"   }, "s",     function () wallpapers_update() end),

    awful.key({ modkey }, "b", function ()
         wibox[mouse.screen].visible = not wibox[mouse.screen].visible
    end),

    awful.key({ modkey }, "p", function () sexec("xrandr --output LVDS1 --auto --output HDMI1 --auto; sleep 1; xrandr --output LVDS1 --primary --right-of HDMI1") end),
    awful.key({ modkey }, "l", function () sexec("xrandr --output LVDS1 --auto: --output HDMI1 --auto; sleep 1; xrandr --output HDMI1 --primary") end),

    -- Prompt
    awful.key({ modkey },            "r",     function () promptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    awful.key({ }, "XF86AudioRaiseVolume", function ()
       exec("amixer -q set PCM 1dB+")
       exec("amixer -q set Master 100%")
       exec("amixer -q set 'Speaker Boost' 100%")
       exec("amixer -q set PCM unmute")
       exec("amixer -q set Master unmute")
       exec("amixer -q set 'Speaker Boost' unmute") end),
    awful.key({ }, "XF86AudioLowerVolume", function ()
       exec("amixer -q set PCM 1dB-")
       exec("amixer -q set Master 100%")
       exec("amixer -q set 'Speaker Boost' 100%")
       exec("amixer -q set PCM unmute")
       exec("amixer -q set Master unmute")
       exec("amixer -q set 'Speaker Boost' unmute") end),
    awful.key({ }, "XF86AudioMute", function ()
       exec("amixer -q set Master mute") end),
    awful.key({ }, "XF86AudioPrev", function ()
       exec("qmmp --previous") end),
    awful.key({ }, "XF86AudioNext", function ()
       exec("qmmp --next") end),
    awful.key({ }, "XF86AudioPlay", function ()
       exec("qmmp -t") end),
    awful.key({ "Control" }, "XF86AudioPrev", function ()
       exec("qmmp --seek-bwd 5") end),
    awful.key({ "Control" }, "XF86AudioNext", function ()
       exec("qmmp --seek-fwd 5") end),
    awful.key({ }, "Print", function ()
       exec("gnome-screenshot -i") end),

    awful.key({ modkey }, "d", function ()
       if instance then
           instance:hide()
           instance = nil
       else
           instance = awful.menu.clients({ width=1000 }, { keygrabber=true })
       end
   end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey,           }, "t",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Shift" }, "t", function (c)
        if   c.titlebar then awful.titlebar.remove(c)
           else awful.titlebar.add(c, { modkey = modkey }) end
    end),
    awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "`",      function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
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
awful.rules.rules = {
    { rule = { }, properties = {
      focus = true,      size_hints_honor = false,
      keys = clientkeys, buttons = clientbuttons,
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal }
    },
    { rule = { class = "ROX-Filer" },   properties = { floating = true } },
    { rule = { class = "Plugin-container" },   properties = { floating = true, border_width = 0 } },
    { rule = { class = "Chromium-browser" },   properties = { floating = false } },
    { rule = { class = "Google-chrome" },   properties = { floating = false } },
--    { rule = { class = "Firefox" },   properties = { floating = false, tag = tags[1][2] } },
    { rule = { class = "Skype" },   properties = { floating = false, tag = tags[1][1] } },
    { rule = { class = "Qmmp" },   properties = { floating = true, tag = tags[1][6] } },
    { rule = { class = "Firefox", instance = "startup" }, properties = { floating = false, tag = tags[1][2]} },
}
-- }}}

-- {{{ Signals
--
-- {{{ Manage signal handler
client.add_signal("manage", function (c, startup)
    -- Add titlebar to floaters, but remove those from rule callback
    if awful.client.floating.get(c)
    or awful.layout.get(c.screen) == awful.layout.suit.floating then
        if   c.titlebar then awful.titlebar.remove(c)
        else awful.titlebar.add(c, {modkey = modkey}) end
    end

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function (c)
        if  awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Client placement
    if not startup then
        awful.client.setslave(c)

        if  not c.size_hints.program_position
        and not c.size_hints.user_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
-- }}}

-- {{{ Focus signal handlers
client.add_signal("focus",   function (c) c.border_color = beautiful.border_focus  end)
client.add_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:add_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    for _, c in pairs(clients) do -- Floaters are always on top
        if   awful.client.floating.get(c) or layout == "floating"
        then if not c.fullscreen then c.above       =  true  end
        else                          c.above       =  false end
    end
  end)
end
-- }}}
-- }}}



require_safe('wallpapers')
require_safe('autorun')
