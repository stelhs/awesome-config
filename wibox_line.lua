-- {{{ Wibox
--
-- {{{ Widgets configuration
--
-- {{{ Reusable separator
separator = widget({ type = "imagebox" })
separator.image = image(beautiful.widget_sep)

spacer = widget({ type = "textbox" })
spacer.width = 3
-- }}}

-- {{{ CPU usage

-- cpu icon
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)

-- Initialize widget
cpugraph  = awful.widget.graph()

-- Graph properties
cpugraph:set_width(40):set_height(16)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_gradient_angle(0):set_gradient_colors({
   beautiful.fg_end_widget, beautiful.fg_center_widget, beautiful.fg_widget
})

-- Register graph widget
vicious.register(cpugraph,  vicious.widgets.cpu,      "$1")

-- cpu text widget
cpuwidget = widget({ type = "textbox" }) -- initialize
vicious.register(cpuwidget, vicious.widgets.cpu, " $1%", 3) -- register

-- temperature
tzswidget = widget({ type = "textbox" })
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


-- {{{ Battery state

-- Initialize widget
batwidget = widget({ type = "textbox" })
baticon = widget({ type = "imagebox" })

-- Register widget
vicious.register(batwidget, vicious.widgets.bat,
	function (widget, args)
		if args[2] == 0 then return ""
		else
			baticon.image = image(beautiful.widget_bat)
			return args[1] .. "<span color='white'>".. args[2] .. "%</span>"
		end
	end, 61, "BAT1"
)
-- }}}


-- {{{ Memory usage
-- icon
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)

-- mem text output
memtext = widget({ type = "textbox" })
vicious.register(memtext, vicious.widgets.mem, " $1%", 15)
-- }}}


-- {{{ Network usage
function print_net(name, down, up)
	return '<span color="'
	.. beautiful.fg_netdn_widget ..'">' .. down .. '</span> <span color="'
	.. beautiful.fg_netup_widget ..'">' .. up  .. '</span>'
end

dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })

-- Initialize widget
netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net,
	function (widget, args)
		for _,device in pairs({'eth4', 'wlan1'}) do
			if tonumber(args["{".. device .." carrier}"]) > 0 then
				netwidget.found = true
				dnicon.image = image(beautiful.widget_net)
				upicon.image = image(beautiful.widget_netup)
				return print_net(device, args["{"..device .." down_kb}"], args["{"..device.." up_kb}"])
			end
		end
	end, 3)
-- }}}



-- {{{ Volume level
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = widget({ type = "textbox" })
-- Progressbar properties
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(16):set_width(5):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "PCM")
vicious.register(volwidget, vicious.widgets.volume, " $1%", 2, "PCM")
-- Register buttons
volbar.widget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () exec("kmix") end),
   awful.button({ }, 4, function () exec("amixer -q set PCM 2dB+", false) vicious.force({volbar, volwidget}) end),
   awful.button({ }, 5, function () exec("amixer -q set PCM 2dB-", false) vicious.force({volbar, volwidget}) end)
)) -- Register assigned buttons
volwidget:buttons(volbar.widget:buttons())
-- }}}

-- {{{ Date and time
dateicon = widget({ type = "imagebox" })
dateicon.image = image(beautiful.widget_date)
-- Initialize widget
datewidget = widget({ type = "textbox" })
-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%a %d.%m.%Y %H:%M", 61)
-- }}}

-- {{{ Raid
raid_widget = widget({ type = "textbox" })
vicious.register(raid_widget, vicious.widgets.raid, 
	function (widget, args)
		local msg
		msg = "Raid:" .. args["active"] .. "/" .. args["assigned"]
		if args["resync"] then
			msg = msg .. " Resync " .. args["resync"] .. "% "
			msg = msg .. args["curr_speed"] .. "/" .. args["max_speed"] .. "K/sec "
		end
		return msg
	end
	, 30, "md0")
-- }}}


-- {{{ System tray
systray = widget({ type = "systray" })
-- }}}
-- }}}

-- {{{ Wibox initialisation
wibox     = {}
promptbox = {}
layoutbox = {}
taglist   = {}
taglist.buttons = awful.util.table.join(
    awful.button({ },        1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ },        3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ },        4, awful.tag.viewnext),
    awful.button({ },        5, awful.tag.viewprev
))

for s = 1, screen.count() do
    -- Create a promptbox
    promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create a layoutbox
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))

    -- Create the taglist
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)
    -- Create the wibox
    wibox[s] = awful.wibox({      screen = s,
        fg = beautiful.fg_normal, height = 12,
        bg = beautiful.bg_normal, position = "top",
        border_color = beautiful.border_normal,
        border_width = beautiful.border_width
    })

	-- Create a tasklist widget
    current_task = awful.widget.tasklist(
        function(c)
                return awful.widget.tasklist.label.focused(c, s)
        end, nil)

    -- Add widgets to the wibox
    wibox[s].widgets = {
        {   mylauncher, taglist[s], layoutbox[s], separator, promptbox[s],
            mpdwidget and spacer, mpdwidget or nil,
            ["layout"] = awful.widget.layout.horizontal.leftright
        },
        --s == screen.count() and systray or nil, -- show tray on last screen
        s == 1 and systray or nil, -- only show tray on first screen
        s == 1 and separator or nil, -- only show on first screen
        datewidget, dateicon,
        baticon.image and separator, batwidget, baticon or nil,
        separator, volwidget,  volbar.widget, volicon,
        dnicon.image and separator, upicon, netwidget, dnicon or nil,
        separator, memtext, memicon,
        separator, tzfound and tzswidget or nil,
        separator, cpugraph.widget or nil, cpuicon,
        separator, raid_widget,
        current_task,
        ["layout"] = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}
-- }}}
