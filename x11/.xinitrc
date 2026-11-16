#!/bin/sh
# ~/.xinitrc - dwm amarelo Tango no OpenBSD (iniciar com: startx)

# ~/bin no PATH tambem no login pelo xenodm (printar, dwm-status)
case ":$PATH:" in *":$HOME/bin:"*) ;; *) PATH="$HOME/bin:$PATH"; export PATH ;; esac

xrdb -merge ~/.Xresources
# wallpaper: o ~/.fehbg e criado pelo feh (feh --bg-fill imagem);
# sem ele, fundo solido Tango (Aluminium 6)
xsetroot -solid "#2e3436"
[ -f ~/.fehbg ] && sh ~/.fehbg

# barra: volume, bateria e data (script em ~/bin/dwm-status)
~/bin/dwm-status &

exec dwm
