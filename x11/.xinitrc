#!/bin/sh
# ~/.xinitrc - dwm Gruvbox no OpenBSD (iniciar com: startx)

xrdb -merge ~/.Xresources
# wallpaper: o ~/.fehbg e criado pelo feh (feh --bg-fill imagem);
# sem ele, fundo solido Gruvbox
xsetroot -solid "#282828"
[ -f ~/.fehbg ] && sh ~/.fehbg

# barra: volume, bateria e data (script em ~/bin/dwm-status)
~/bin/dwm-status &

exec dwm
