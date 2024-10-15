#!/bin/bash

path=~/screenshots/
file=`date +"%Y_%m_%d_%H_%M_%S"`.png
url=http://sr90.org/screenshots/
fullfile=$path$file
sleep 0.2; gnome-screenshot -a -f $fullfile 2> ~/.config/awesome/err
#sleep 0.2; scrot -s '%Y_%m_%d_%H_%M_%S.png' -e 'mv $f ~/screenshots' 2> ~/.config/awesome/err
if [ $? -eq 0 ]
then
    scp $fullfile stelhs@sr90.org:/storage/www/screenshots
    echo $url$file | xclip -selection c
    ~/.config/awesome/send_msg.sh "screenshot was uploaded $url$file" 5
else
    ~/.config/awesome/send_msg.sh "gnome-screenshot return error" 5
fi
