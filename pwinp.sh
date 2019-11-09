#! /bin/bash

get_help() {
  cat <<EOF
  h | ? - Show help
  i - Set target index
  g - Set gap size in px
  t - Load id from /tmp/.pwinp_id
  p - Set position:
    - c: Center
    - l: Left
    - r: Right
    - u: Up
    - d: Down
    - /[clrud]{2}/: Screen corners
EOF
}

# Assumes G, dwidth, dheight, wx, wy, wwidth, wheight to be set beforehand.
# Sets new_x, new_y
# Only argument it takes is a directive
get_pos() {
  case $1 in
  u)
    newy=$G
    # echo u $newx $newy
    ;;
  r)
    let newx=$dwidth-$wwidth-$G 
    # echo r $newx $newy
    ;;
  d)
    let newy=$dheight-$wheight-$G 
    # echo d $newx $newy
    ;;
  l)
    newx=$G
    # echo l $newx $newy
    ;;
  c)
    let newx=$dwidth/2-$wwidth/2
    let newy=$dheight/2-$wheight/2
    # echo c $newx $newy
  esac
}

ID=""
P=c
G=20
T=""

while getopts "h?i:p:g:t" opt; do
  case $opt in
  h|\?)
    get_help
    ;;
  i)
    ID=$OPTARG 
    ;;
  p)
    P=$OPTARG 
    ;;
  g)
    G=$OPTARG
    ;;
  t)
    T=1
    ;;
  esac
done

if [ -z "$ID" ]; then
  ID=`xdotool getactivewindow` 
fi

if [ ! -z "$T" ]; then
  ID=`cat /tmp/.pwinp_id`
  # echo $ID
  # rm -f /tmp/.pwinp_id
fi

winfo=`xwininfo -id $ID`

wx=`xwininfo -id $ID | sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/\1/p"`
wy=`xwininfo -id $ID | sed -n -e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/\1/p"`
wwidth=`xwininfo -id $ID | sed -n -r 's/ *Width: ([0-9]*)/\1/p'`
wheight=`xwininfo -id $ID | sed -n -r 's/ *Height: ([0-9]*)$/\1/p'`

dinfo=`xdotool getdisplaygeometry`
dwidth=`echo $dinfo | cut -d " " -f1`
dheight=`echo $dinfo | cut -d " " -f2`

newx=$wx
newy=$wy

[[ $P =~ c ]] && get_pos c

[[ $P =~ u ]] && get_pos u
[[ $P =~ r ]] && get_pos r
[[ $P =~ d ]] && get_pos d
[[ $P =~ l ]] && get_pos l

if [ ! -z "$newx" ] && [ ! -z "$newy" ]; then
  
  # echo $newx $newy

  xdotool windowmove $ID $newx $newy
fi
