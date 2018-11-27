wallpaper_dirs = {"'/home/stelhs/MyPhoto/Объекты/'",
                  "'/home/stelhs/MyPhoto/Походы/'",
                  "'/home/stelhs/MyPhoto/Поездки/'",
                  "'/home/stelhs/MyPhoto/Прогулки/'",
                  "'/home/stelhs/MyPhoto/Минск/Старый минск/'"}

os.execute("/home/stelhs/.config/awesome/wallpaper_random.php init")

wallpapers_timer = timer { timeout = 0 }
wallpapers_timer:connect_signal("timeout", function()
  if whereis_app('feh') then
    os.execute("/home/stelhs/.config/awesome/wallpaper_random.php update")
  end
  wallpapers_timer:stop()
  wallpapers_timer.timeout = math.random( 600, 1200)
  wallpapers_timer:start()
end)
wallpapers_timer:start()

function wallpapers_update()  
  os.execute("/home/stelhs/.config/awesome/wallpaper_random.php update")
  wallpapers_timer:stop()
  wallpapers_timer.timeout = math.random( 600, 1200)
  wallpapers_timer:start()
end
