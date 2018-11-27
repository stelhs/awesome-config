#!/bin/bash

path=/home/stelhs/screenshots/
file=`date +"%Y_%m_%d_%H_%M_%S"`.png
url=http://sr38.org/screenshots/
fullfile=$path$file
sleep 0.2; gnome-screenshot -a -f $fullfile 2> /home/stelhs/.config/awesome/err
#sleep 0.2; scrot -s '%Y_%m_%d_%H_%M_%S.png' -e 'mv $f ~/screenshots' 2> /home/stelhs/.config/awesome/err
if [ $? -eq 0 ]
then
    scp $fullfile stelhs@sr38.org:/storage/www/screenshots
    echo $url$file | xclip -selection c
    /home/stelhs/.config/awesome/send_msg.sh "screenshot was uploaded $url$file" 5
else
    /home/stelhs/.config/awesome/send_msg.sh "gnome-screenshot return error" 5
fi
