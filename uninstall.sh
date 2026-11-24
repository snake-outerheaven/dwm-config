#!/bin/sh
# uninstall.sh - desfaz o install.sh do dwm-config no FreeBSD
#
# Uso (na raiz do repositorio):
#   sh uninstall.sh -n       so mostra o que faria, sem mudar nada
#   sh uninstall.sh          remove
#
# O que sai:
#   /usr/local/bin/dwm, /usr/local/bin/st e as manpages      (make uninstall)
#   /usr/local/libexec/dwm-config/                            scripts
#   /usr/local/share/dwm-config/                              Xresources, dunstrc, fundo
#   /etc/dwm-config/                                          perfil da maquina
#   links do stow no $HOME (x11, cmus, mpv)                   so os que apontam para este repo
#
# O que fica (de proposito):
#   os pacotes do pkg      outros programas podem depender deles; o fim do script
#                          mostra o comando para remover os que voce quiser
#   ~/.dotfiles-backup-*   os seus arquivos antigos; o fim do script mostra onde estao
#   ~/bin                  nunca e tocado
#   o terminfo do st       ~/.terminfo ou /usr/share/misc; inofensivo
#
# A sessao atual continua rodando: saia do dwm depois.

set -u

SIMULAR=0
[ "${1:-}" = "-n" ] && SIMULAR=1

REPO=$(cd "$(dirname "$0")" && pwd)
LIBEXEC=/usr/local/libexec/dwm-config
SHARE=/usr/local/share/dwm-config
ETC=/etc/dwm-config
STOW_PACOTES="x11 cmus mpv"

msg()  { printf '\033[33m==>\033[0m %s\n' "$*"; }
aviso(){ printf '\033[31m!!\033[0m %s\n' "$*"; }

rodar() {
	if [ "$SIMULAR" -eq 1 ]; then
		printf '    [simulado] %s\n' "$*"
	else
		"$@"
	fi
}

# root: doas se estiver configurado, senao sudo (igual ao install.sh)
if command -v doas >/dev/null && [ -f /usr/local/etc/doas.conf ]; then
	SU=doas
else
	SU=sudo
fi

# 1. conferencias
[ "$(uname -s)" = FreeBSD ] || { aviso "Esta branch e para FreeBSD."; exit 1; }
command -v "$SU" >/dev/null || { aviso "Nem doas nem sudo encontrados."; exit 1; }
[ -f "$REPO/dwm/Makefile" ] && [ -f "$REPO/st/Makefile" ] || { aviso "Rode na raiz do dwm-config."; exit 1; }
[ "$SIMULAR" -eq 1 ] && msg "Modo simulacao: nada sera alterado."

# 2. barra: para o dwm-status, que roda a partir do $LIBEXEC
if pgrep -f "$LIBEXEC/dwm-status" >/dev/null 2>&1; then
	msg "Parando a barra (dwm-status)"
	rodar pkill -f "$LIBEXEC/dwm-status"
fi

# 3. links do stow no $HOME: so remove o que aponta para este repositorio
msg "Removendo os links do stow: $STOW_PACOTES"
for pac in $STOW_PACOTES; do
	[ -d "$REPO/$pac" ] || continue
	( cd "$REPO/$pac" && find . -type f ) | while read -r f; do
		alvo="$HOME/${f#./}"
		if [ -L "$alvo" ]; then
			case "$(readlink "$alvo")" in
			*dwm-config/"$pac"/*) printf '    %s\n' "$alvo"; rodar rm "$alvo" ;;
			*) printf '    %s aponta para outro lugar: fica\n' "$alvo" ;;
			esac
		elif [ -e "$alvo" ]; then
			printf '    %s nao e link do stow: fica\n' "$alvo"
		fi
	done
done
# pastas que o stow criou e ficaram vazias (rmdir nao apaga pasta com arquivo)
for d in "$HOME/.config/cmus" "$HOME/.config/mpv"; do
	[ -d "$d" ] && rodar rmdir "$d" 2>/dev/null
done

# 4. dwm e st: o make uninstall de cada um
msg "Removendo o dwm e o st (make uninstall)"
rodar $SU make -C "$REPO/dwm" uninstall || aviso "make uninstall do dwm falhou (seguindo)"
rodar $SU make -C "$REPO/st" uninstall || aviso "make uninstall do st falhou (seguindo)"

# 5. scripts, arquivos compartilhados e perfil
for d in "$LIBEXEC" "$SHARE" "$ETC"; do
	if [ -d "$d" ]; then
		msg "Removendo $d"
		rodar $SU rm -r "$d"
	fi
done

# 6. resumo
msg "Pronto."
printf '    Os pacotes ficaram instalados. Para remover os que eram so do dwm-config:\n'
printf '      %s pkg delete dmenu i3lock xautolock dunst copyq feh scrot cmus playerctl\n' "$SU"
printf '      %s pkg autoremove\n' "$SU"
for b in "$HOME"/.dotfiles-backup-*; do
	[ -d "$b" ] && printf '    Backup dos seus arquivos antigos: %s\n' "$b"
done
msg "Saia do dwm (Alt+Shift+q). O ~/.xinitrc foi removido: crie um novo antes do proximo startx."
