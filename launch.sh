#! /bin/bash

ID=`xdotool getactivewindow`

echo $ID > /tmp/.pwinp_id

i3-msg mode \"Move to: [c]:enter [h]:left [j]:down [k]:up [l]:right [Esc],[Enter]:Leave\"
