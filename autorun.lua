-- run_once("xscreensaver", "-no-splash")         -- starts screensaver daemon 
-- run_once("xsetroot", "-cursor_name left_ptr")  -- sets the cursor icon

--run_once("redshift", "-o -l 0:0 -b 0.5 -t 6500:6500") -- brightness
-- run_once("ibus-daemon", "--xim") -- ibus
-- run_once(os.getenv("HOME") .. "/.dropbox-dist/dropboxd") -- dropbox
run_once("nm-applet") -- networking

-- run_once("wmname", "LG3D") -- java fix

run_once("killall", "ibus-daemon")
-- run_once("setxkbmap", "-option")
-- run_once("setxkbmap", "us")
run_once("setxkbmap", "-layout 'us,ru' -option grp:shift_caps_switch,grp_led:caps")
run_once("kbdd")
--run("xkbcomp $DISPLAY - | egrep -v \"group . = AltGr;\" | xkbcomp - $DISPLAY")

-- os.execute("/usr/bin/gnome-screensaver --no-daemon")
-- os.execute("gnome-sound-applet &")
--run_once("gnome-settings-daemon")
-- run_once("kmix")
run_once("sudo xfce4-power-manager")
run_once("parcellite")
--run_once("setxkbmap", "-layout 'us,ru' -option grp:shift_caps_switch,grp_led:caps")
--run_once("awsetbg /home/dg/Pictures/Wallpaper/Savannah_Lilian_Blot_by_a_Blot_on_the_landscape.jpg")
run_once("goldendict")
run_once("skype")
run_once("/opt/telegram/Telegram")
run_once("firefox")
run_once("qmmp")

