
wallpaper_dirs = {"'/home/stelhs/MyPhoto/Объекты/'",
                  "'/home/stelhs/MyPhoto/Походы/'"}

os.execute("rm /tmp/wallpaper_list")
for _,path in pairs(wallpaper_dirs) do
  os.execute("find " .. path .. " -type f -name '*.jpg' -print0 >> /tmp/wallpaper_list")
  os.execute("find " .. path .. " -type f -name '*.JPG' -print0 >> /tmp/wallpaper_list")
end

mytimer = timer { timeout = 0 }
mytimer:add_signal("timeout", function()
  if whereis_app('feh') then
	  os.execute("cat /tmp/wallpaper_list | shuf -n1 -z | xargs -0 feh --bg-scale")
  end
  mytimer:stop()
  mytimer.timeout = math.random( 60, 120)
  mytimer:start()
end)
mytimer:start()
