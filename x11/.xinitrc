#!/bin/sh
# ~/.xinitrc - dwm amarelo Tango no OpenBSD (iniciar com: startx)

xrdb -merge ~/.Xresources
# wallpaper: o ~/.fehbg e criado pelo feh (feh --bg-fill imagem);
# sem ele, fundo solido Tango (Aluminium 6)
xsetroot -solid "#2e3436"
[ -f ~/.fehbg ] && sh ~/.fehbg

# barra: volume, bateria e data (script em ~/bin/dwm-status)
~/bin/dwm-status &

exec dwm
