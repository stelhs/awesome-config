local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

-- {{{ Wibox

separator = wibox.widget.imagebox()
separator:set_image(beautiful.widget_sep)

-- {{{ Date and time
dateicon = wibox.widget.imagebox()
dateicon:set_image(beautiful.widget_date)
datewidget = wibox.widget.textbox()
vicious.register(datewidget, vicious.widgets.date, "%a %d.%m.%Y %H:%M", 61)
-- }}}

-- {{{ Volume level
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = wibox.widget.textbox()
-- Progressbar properties
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(16):set_width(5):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
--volbar:set_gradient_colors({ beautiful.fg_widget,
--   beautiful.fg_center_widget, beautiful.fg_end_widget
--}) -- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "PCM")
vicious.register(volwidget, vicious.widgets.volume, " $1%", 2, "PCM")
-- }}}

-- {{{ Network usage
function print_net(name, down, up)
    return '<span color="'
    .. beautiful.fg_netdn_widget ..'">' .. down .. '</span> <span color="'
    .. beautiful.fg_netup_widget ..'">' .. up  .. '</span>'
end

dnicon = wibox.widget.imagebox()
upicon = wibox.widget.imagebox()

netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net,
    function (widget, args)
        for _,device in pairs({'eth4', 'wlan1'}) do
            if tonumber(args["{".. device .." carrier}"]) > 0 then
                netwidget.found = true
                dnicon:set_image(beautiful.widget_net)
                upicon:set_image(beautiful.widget_netup)
                return print_net(device, args["{"..device .." down_kb}"], args["{"..device.." up_kb}"])
            end
        end
    end, 3)
-- }}}

-- {{{ Memory usage
-- icon
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memtext = wibox.widget.textbox()
vicious.register(memtext, vicious.widgets.mem, " $1%", 15)
-- }}}

-- {{{ Battery state
batwidget = wibox.widget.textbox()
baticon = wibox.widget.imagebox()
vicious.register(batwidget, vicious.widgets.bat,
    function (widget, args)
        if args[2] == 0 then return ""
        else
            baticon:set_image(beautiful.widget_bat)
            return args[1] .. "<span color='white'>".. args[2] .. "%</span>"
        end
    end, 61, "BAT0"
)
-- }}}


-- {{{ CPU usage
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)

-- Initialize widget
cpugraph  = awful.widget.graph()

-- Graph properties
cpugraph:set_width(40):set_height(16)
cpugraph:set_background_color(beautiful.fg_off_widget)
--cpugraph:set_gradient_angle(0):set_gradient_colors({
--   beautiful.fg_end_widget, beautiful.fg_center_widget, beautiful.fg_widget
--})

-- Register graph widget
vicious.register(cpugraph,  vicious.widgets.cpu,      "$1")

-- cpu text widget
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, " $1%", 3) -- register

-- temperature
tzswidget = wibox.widget.textbox()
vicious.register(tzswidget, vicious.widgets.thermal,
    function (widget, args)
        if args[1] > 0 then
            tzfound = true
            return " " .. args[1] .. "C°"
        else return "" 
        end
    end
    , 19, "thermal_zone0")

-- }}}


-- Etherium rate
ethWidget = wibox.widget.textbox()
vicious.register(ethWidget, 
    function ()
      local cmd = "printf '%.*f\n' 1 `curl -s 'https://api.binance.com/api/v3/ticker/price?symbol=ETHUSDT' | jq -r '.price'`"
      local f = io.popen(cmd, 'r')
      local content = f:read('*a')
      f:close()
      return "ETH:" .. content .. "$"
    end,
    "$1"
    , 1, "")

-- }}}


-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ screen = s,
            fg = beautiful.fg_normal, height = 14,
            bg = beautiful.bg_normal, position = "top",
            border_color = beautiful.border_normal,
            border_width = beautiful.border_width
        })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()

    right_layout:add(ethWidget)
    right_layout:add(separator)
    
    right_layout:add(cpuicon)
    right_layout:add(cpugraph)
    right_layout:add(separator)

    right_layout:add(tzfound and tzswidget or nil)
    right_layout:add(separator)

    right_layout:add(memicon)
    right_layout:add(memtext)
    right_layout:add(separator)


    right_layout:add(dnicon or nil)
    right_layout:add(netwidget)
    right_layout:add(upicon)
    right_layout:add(separator)

    right_layout:add(volicon)
    right_layout:add(volbar)
    right_layout:add(volwidget)
    right_layout:add(separator)

    right_layout:add(baticon or nil)
    right_layout:add(batwidget)
    right_layout:add(separator)

    right_layout:add(dateicon)
    right_layout:add(datewidget)
    if s == 1 then right_layout:add(wibox.widget.systray()) end


--    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}
