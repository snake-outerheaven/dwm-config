#!/bin/sh
# install.sh - instala as ferramentas do ambiente dwm amarelo Tango no OpenBSD
#
# Uso (na raiz do repositorio):
#   sh install.sh            instala pacotes, compila dwm e st e aplica os dotfiles
#   sh install.sh -n         so mostra o que faria, sem mudar nada
#
# Nada e apagado: arquivos que atrapalham o stow vao para ~/.dotfiles-backup-DATA.

set -u

SIMULAR=0
[ "${1:-}" = "-n" ] && SIMULAR=1

REPO=$(cd "$(dirname "$0")" && pwd)
DWM_DIR="$REPO/dwm"
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# pacotes essenciais (o ambiente nao sobe sem eles)
ESSENCIAIS="dmenu stow"
# o st vem compilado da pasta st/ do repositorio (scrollback, reflow, modo vi)
# pacotes opcionais (o ambiente sobe sem eles; falha vira aviso)
OPCIONAIS="git vim--no_x11 fastfetch cascadia-code feh scrot i3lock xdg-user-dirs"
# pacotes stow aplicados no $HOME
STOW_PACOTES="x11"

falhas=""

msg()  { printf '\033[33m==>\033[0m %s\n' "$*"; }
aviso(){ printf '\033[31m!!\033[0m %s\n' "$*"; }

rodar() {
	if [ "$SIMULAR" -eq 1 ]; then
		printf '    [simulado] %s\n' "$*"
	else
		"$@"
	fi
}

# 1. conferencias
[ "$(uname -s)" = "OpenBSD" ] || { aviso "Este script e para OpenBSD."; exit 1; }
command -v doas >/dev/null || { aviso "doas nao encontrado. Configure o /etc/doas.conf."; exit 1; }
[ -f "$DWM_DIR/config.h" ] && [ -f "$REPO/st/config.h" ] || { aviso "Arvore incompleta: faltam dwm/ ou st/ ao lado do install.sh."; exit 1; }
[ "$SIMULAR" -eq 1 ] && msg "Modo simulacao: nada sera alterado."

# 2. pacotes
msg "Instalando pacotes essenciais: $ESSENCIAIS"
for p in $ESSENCIAIS; do
	if pkg_info -e "$p-*" >/dev/null 2>&1; then
		printf '    %s ja instalado\n' "$p"
	else
		rodar doas pkg_add -I "$p" || { aviso "Falhou: $p"; exit 1; }
	fi
done

msg "Instalando pacotes opcionais: $OPCIONAIS"
for p in $OPCIONAIS; do
	base=${p%%--*}
	if pkg_info -e "$base-*" >/dev/null 2>&1; then
		printf '    %s ja instalado\n' "$base"
	else
		rodar doas pkg_add -I "$p" || { aviso "Nao instalou: $p (seguindo)"; falhas="$falhas $p"; }
	fi
done

# 3. compilar e instalar o dwm
msg "Compilando o dwm"
( cd "$DWM_DIR" && rodar make clean && rodar make ) || { aviso "Falha ao compilar o dwm."; exit 1; }
rodar doas make -C "$DWM_DIR" install || { aviso "Falha ao instalar o dwm."; exit 1; }

# 3b. compilar e instalar o st do repositorio
ST_DIR="$REPO/st"
if pkg_info -e 'st-*' >/dev/null 2>&1; then
	msg "Removendo o st do pacote (o do repositorio substitui)"
	rodar doas pkg_delete st || aviso "Nao removeu o pacote st (seguindo)"
fi
msg "Compilando o st"
( cd "$ST_DIR" && rodar make clean && rodar make ) || { aviso "Falha ao compilar o st."; exit 1; }
rodar doas make -C "$ST_DIR" install || { aviso "Falha ao instalar o st."; exit 1; }

# 4. dotfiles com stow (com backup do que atrapalhar)
msg "Aplicando dotfiles: $STOW_PACOTES"
for pac in $STOW_PACOTES; do
	[ -d "$REPO/$pac" ] || { aviso "Pacote $pac nao existe no repositorio (seguindo)"; continue; }
	( cd "$REPO/$pac" && find . -type f ) | while read -r f; do
		alvo="$HOME/${f#./}"
		if [ -e "$alvo" ] && [ ! -L "$alvo" ]; then
			destino="$BACKUP/${f#./}"
			printf '    backup: %s -> %s\n' "$alvo" "$destino"
			rodar mkdir -p "$(dirname "$destino")"
			rodar mv "$alvo" "$destino"
		fi
	done
	rodar stow --no-folding -d "$REPO" -t "$HOME" "$pac" || aviso "stow falhou em $pac"
done

# 5. resumo
msg "Pronto."
[ -n "$falhas" ] && aviso "Pacotes opcionais que nao instalaram:$falhas"
pkg_info -e 'cascadia-code-*' >/dev/null 2>&1 || \
	aviso "Fonte Cascadia Code nao veio de pacote: coloque os .ttf em ~/.fonts e rode fc-cache."
[ -d "$BACKUP" ] && msg "Arquivos antigos guardados em $BACKUP"
msg "Saia da sessao atual e rode: startx"
