#! /bin/bash

ID=`xdotool getactivewindow`

echo $ID > /tmp/.pwinp_id

i3-msg mode \"$@\"
