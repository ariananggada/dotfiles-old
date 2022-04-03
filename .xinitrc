# load profile
. $HOME/.profile

# use UTF-8 everywhere
export LANG=en_US.UTF-8

# # specify location of kshrc
# export ENV=$HOME/.kshrc

# load Xresources file
xrdb -merge $HOME/.Xresources

# use caps lock as ctrl key
setxkbmap -option caps:escape

# set your background color
# xsetroot -solid dimgray

# gnome keyring daemon
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)

# Fix Gnome Apps Slow  Start due to failing services
# # Add this when you include flatpak in your system
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# my init
mpd &
feh --bg-center ~/.local/share/wall.jpg &
xcompmgr &
dunst &
xset r rate 300 50 &
redshift -c $HOME/.config/redshift/redshift.conf &
dwmblocks &

# disable system beep
xset b off

# # for openbsd
# # if you have a ThinkPad, the following lines enable TrackPoint
# # scrolling by dragging with the middle button.
# xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation" 1 
# xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Button" 2 
# xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Axes" 6 7 4 5 

# exec $HOME/.config/polybar/launch.sh

# # start fvwm!
# exec fvwm

# # start cwm!
# exec cwm

# start dwm!
exec dwm
