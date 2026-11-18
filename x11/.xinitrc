#!/bin/sh
# ~/.xinitrc - dwm amarelo Tango no OpenBSD (iniciar com: startx)
# Os programas da sessao (barra, dunst, copyq, xidle) o proprio dwm sobe:
# veja autostart[] em ~/dwm-config/dwm/config.h. Nada aqui usa o seu ~/bin.

# barramento D-Bus da sessao: o dunst e o copyq precisam dele
if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ] && command -v dbus-launch >/dev/null; then
	eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# cores do terminal: as do dwm-config e, por cima, as suas (se houver)
xrdb -merge /usr/local/share/dwm-config/Xresources
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# fundo solido Tango; se voce criou um wallpaper com o feh, ele vence
xsetroot -solid "#2e3436"
[ -f ~/.fehbg ] && sh ~/.fehbg

exec dwm
