#!/bin/sh
# ~/.xinitrc - dwm amarelo Tango no OpenBSD (iniciar com: startx)

# ~/bin no PATH tambem no login pelo xenodm (printar, dwm-status)
case ":$PATH:" in *":$HOME/bin:"*) ;; *) PATH="$HOME/bin:$PATH"; export PATH ;; esac

# barramento D-Bus da sessao: o dunst e o copyq precisam dele
if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ] && command -v dbus-launch >/dev/null; then
	eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

xrdb -merge ~/.Xresources
# wallpaper: o ~/.fehbg e criado pelo feh (feh --bg-fill imagem);
# sem ele, fundo solido Tango (Aluminium 6)
xsetroot -solid "#2e3436"
[ -f ~/.fehbg ] && sh ~/.fehbg

# barra: cpu, memoria, volume, bateria e data (script em ~/bin/dwm-status)
~/bin/dwm-status &

# notificacoes (dunst) e historico do clipboard (copyq, Alt+v)
command -v dunst >/dev/null && dunst &
command -v copyq >/dev/null && copyq &

# bloqueio apos 5 min parado: o xidle (base) chama o i3lock; -no = sem canto de bloqueio
# SIGUSR1 ao xidle bloqueia na hora (o /etc/apm/suspend usa)
[ -x /usr/local/bin/i3lock ] &&
    xidle -no -timeout 300 -program "/usr/local/bin/i3lock -c 2e3436" &

exec dwm
