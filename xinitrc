#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi


# set mouse speed and stuff
xinput --set-prop 'PS2++ Logitech Wheel Mouse' 'libinput Accel Speed' 0.5
xinput --set-prop 'Logitech USB Optical Mouse' 'libinput Accel Speed' -0.5

#twm &
#xclock -geometry 50x50-1+1 &
#xterm -geometry 80x50+494+51 &
#xterm -geometry 80x20+494-0 &
#exec xterm -geometry 80x66+0+0 -name login
if test $(tty) == /dev/tty1;
then
#	xsetroot -cursor_name X_cursor
# see https://tronche.com/gui/x/xlib/appendix/b/
	exec i3
else
	# set postition of monitors
#	xrandr --output DVI1
#	xrandr --output VGA1 --left-of VGA1
	xrandr --output DVI1 --right-of VGA1

	# start twm
	twm &

	# start useful programs
	xclock -geometry 50x50-1+1 &
	xterm -geometry 80x48+1000+0 &
	xterm -geometry 80x48+500+0 &

	# set background color
	xsetroot -solid blue

	# start the main window
	exec xterm -geometry 80x48+0+0 -title login
fi
