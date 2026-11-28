#!/bin/sh
# ~/.xinitrc - dwm Gruvbox no OpenBSD (iniciar com: startx)
# Os programas da sessao (barra, dunst, copyq, xidle) o proprio dwm sobe:
# veja autostart[] em ~/dwm-config/dwm/config.h. Nada aqui usa o seu ~/bin.

# barramento D-Bus da sessao: o dunst e o copyq precisam dele
if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ] && command -v dbus-launch >/dev/null; then
	eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# tema escuro para GTK (Firefox, LibreOffice) e zathura, lido de /usr/local/share/dwm-config;
# os seus arquivos em ~/.config e o seu ~/.gtkrc-2.0, se existirem, vencem
export XDG_CONFIG_DIRS="/usr/local/share/dwm-config/xdg:${XDG_CONFIG_DIRS:-/etc/xdg}"
export GTK2_RC_FILES="/usr/local/share/dwm-config/gtkrc-2.0:$HOME/.gtkrc-2.0"
# o LibreOffice so fica escuro com o tema forcado; defina GTK_THEME antes para trocar
export GTK_THEME="${GTK_THEME:-Adwaita:dark}"

# cores do terminal: as do dwm-config e, por cima, as suas (se houver)
xrdb -merge /usr/local/share/dwm-config/Xresources
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# fundo solido Gruvbox; se voce criou um wallpaper com o feh, ele vence
xsetroot -solid "#282828"
[ -f ~/.fehbg ] && sh ~/.fehbg

exec dwm
