wallpaper_dirs = {"'/home/stelhs/MyPhoto/Объекты/'",
                  "'/home/stelhs/MyPhoto/Походы/'",
                  "'/home/stelhs/MyPhoto/Поездки/'"}

os.execute("rm /tmp/wallpaper_list")
for _,path in pairs(wallpaper_dirs) do
  os.execute("find " .. path .. " -type f -name '*.jpg' -print0 >> /tmp/wallpaper_list")
  os.execute("find " .. path .. " -type f -name '*.JPG' -print0 >> /tmp/wallpaper_list")
end

wallpapers_timer = timer { timeout = 0 }
wallpapers_timer:add_signal("timeout", function()
  if whereis_app('feh') then
	  os.execute("cat /tmp/wallpaper_list | shuf -n1 -z | xargs -0 feh --bg-scale")
  end
  wallpapers_timer:stop()
  wallpapers_timer.timeout = math.random( 600, 1200)
  wallpapers_timer:start()
end)
wallpapers_timer:start()

function wallpapers_update()  
  os.execute("cat /tmp/wallpaper_list | shuf -n1 -z | xargs -0 feh --bg-scale")
  wallpapers_timer:stop()
  wallpapers_timer.timeout = math.random( 600, 1200)
  wallpapers_timer:start()
end
