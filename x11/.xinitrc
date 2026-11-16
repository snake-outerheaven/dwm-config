#!/bin/sh
# ~/.xinitrc - dwm Gruvbox no OpenBSD (iniciar com: startx)

xrdb -merge ~/.Xresources
xsetroot -solid "#282828"

# barra: volume, bateria e data (script em ~/bin/dwm-status)
~/bin/dwm-status &

exec dwm
