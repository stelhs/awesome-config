-----------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Hagen Schink <troja84@googlemail.com>
-----------------------------------------------------

-- {{{ Grab environment
local io = { lines = io.lines }
local setmetatable = setmetatable
local string = {
    len = string.len,
    sub = string.sub,
    match = string.match,
    gmatch = string.gmatch
}
-- }}}


-- Raid: provides state information for a requested RAID array
module("vicious.widgets.raid")


-- Initialize function tables
local mddev = {}

-- {{{ RAID widget type
local function worker(format, warg)
    if not warg then return end
    mddev[warg] = {
        ["found"]    = false,
        ["active"]   = 0,
        ["assigned"] = 0
    }

    -- Linux manual page: md(4)
    for line in io.lines("/proc/mdstat") do
        if string.sub(line, 1, string.len(warg)) == warg then
            mddev[warg]["found"] = true

            for i in string.gmatch(line, "%[[%d]%]") do
                mddev[warg]["assigned"] = mddev[warg]["assigned"] + 1
            end
        elseif mddev[warg]["found"] then
            if line == "" then break end

            local updev = string.match(line, "%[[_U]+%]")
            if updev then
                for i in string.gmatch(updev, "U") do
                    mddev[warg]["active"] = mddev[warg]["active"] + 1
                end
            end

            local resync = string.match(line, "resync = [ ]?([%d%.]+)")
            if resync then
                local curr_speed = string.match(line, "speed=([%d]+)")
                mddev[warg]["resync"] = resync
                mddev[warg]["curr_speed"] = curr_speed
            end
        end
    end

    if mddev[warg]["resync"] then
        for line in io.lines("/sys/block/" .. warg .. "/md/sync_speed_max") do
            local max_speed = string.match(line, "([%d]+)")
            mddev[warg]["max_speed"] = max_speed
        end
    end

    return mddev[warg]
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
