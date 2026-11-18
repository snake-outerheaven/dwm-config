#!/bin/sh
# install.sh - instala o ambiente dwm amarelo Tango no OpenBSD
#
# Uso (na raiz do repositorio):
#   sh install.sh            instala pacotes, compila dwm e st e aplica os dotfiles
#   sh install.sh -n         so mostra o que faria, sem mudar nada
#
# Grupos de programas extras (todos por padrao):
#   GRUPOS="escritorio midia dev"
#   GRUPOS="dev" sh install.sh       so o grupo dev
#   GRUPOS="" sh install.sh          nenhum grupo extra (o escritorio e pesado)
#
# Perfil da maquina (detectado sozinho pela bateria):
#   notebook   barra com bateria e avisos de bateria baixa
#   desktop    sem bateria: a bateria some da barra e nao ha avisos
#   PERFIL=desktop sh install.sh     forca o perfil (grava em ~/.config/dwm-config/perfil)
#
# Nada e apagado: arquivos que atrapalham o stow vao para ~/.dotfiles-backup-DATA.

set -u

SIMULAR=0
[ "${1:-}" = "-n" ] && SIMULAR=1

REPO=$(cd "$(dirname "$0")" && pwd)
DWM_DIR="$REPO/dwm"
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

SO=$(uname -s)

# pacotes: essenciais (o ambiente nao sobe sem eles) e opcionais (falha vira aviso).
# O st vem compilado da pasta st/ do repositorio (scrollback, reflow, modo vi).
case "$SO" in
OpenBSD)
	# i3lock e essencial: Alt+Shift+x e o bloqueio por inatividade (xidle) dependem dele
	ESSENCIAIS="dmenu stow i3lock"
	OPCIONAIS="git vim--no_x11 fastfetch cascadia-code feh scrot xdg-user-dirs dbus dunst libnotify copyq ranger firefox"
	# nomes conferidos no openports.pl
	G_ESCRITORIO="libreoffice libreoffice-i18n-pt-br zathura zathura-pdf-mupdf"
	G_MIDIA="mpv"
	G_DEV="avr-binutils avr-gcc avr-libc avrdude"
	;;
*)
	printf '\033[31m!!\033[0m %s\n' "Sistema nao suportado: $SO (este setup e so para OpenBSD)."
	exit 1
	;;
esac
# pacotes stow aplicados no $HOME
STOW_PACOTES="x11"

falhas=""

msg()  { printf '\033[33m==>\033[0m %s\n' "$*"; }
aviso(){ printf '\033[31m!!\033[0m %s\n' "$*"; }

# grupos extras entram na lista de opcionais (falha vira aviso, como os demais)
GRUPOS="${GRUPOS-escritorio midia dev}"
for g in $GRUPOS; do
	case "$g" in
	escritorio)  OPCIONAIS="$OPCIONAIS $G_ESCRITORIO" ;;
	midia)       OPCIONAIS="$OPCIONAIS $G_MIDIA" ;;
	dev)         OPCIONAIS="$OPCIONAIS $G_DEV" ;;
	*)           aviso "Grupo desconhecido: $g (use escritorio, midia ou dev)" ;;
	esac
done

# pacotes: pkg_add, pkg_info e pkg_delete
instalado() {
	pkg_info -e "${1%%--*}-[0-9]*" >/dev/null 2>&1
}
instalar() {
	rodar doas pkg_add -I "$1"
}
remover() {
	rodar doas pkg_delete "$1"
}

rodar() {
	if [ "$SIMULAR" -eq 1 ]; then
		printf '    [simulado] %s\n' "$*"
	else
		"$@"
	fi
}

# 1. conferencias
msg "Sistema: $SO"
command -v doas >/dev/null || { aviso "doas nao encontrado. Configure o /etc/doas.conf."; exit 1; }
[ -f "$DWM_DIR/config.h" ] && [ -f "$REPO/st/config.h" ] || { aviso "Arvore incompleta: faltam dwm/ ou st/ ao lado do install.sh."; exit 1; }
[ "$SIMULAR" -eq 1 ] && msg "Modo simulacao: nada sera alterado."

# 2. pacotes
msg "Instalando pacotes essenciais: $ESSENCIAIS"
for p in $ESSENCIAIS; do
	if instalado "$p"; then
		printf '    %s ja instalado\n' "$p"
	else
		instalar "$p" || { aviso "Falhou: $p"; exit 1; }
	fi
done

msg "Instalando pacotes opcionais: $OPCIONAIS"
for p in $OPCIONAIS; do
	if instalado "$p"; then
		printf '    %s ja instalado\n' "$p"
	else
		instalar "$p" || { aviso "Nao instalou: $p (seguindo)"; falhas="$falhas $p"; }
	fi
done

# 3. compilar e instalar o dwm
msg "Compilando o dwm"
( cd "$DWM_DIR" && rodar make clean && rodar make ) || { aviso "Falha ao compilar o dwm."; exit 1; }
rodar doas make -C "$DWM_DIR" install || { aviso "Falha ao instalar o dwm."; exit 1; }

# 3b. compilar e instalar o st do repositorio
ST_DIR="$REPO/st"
if instalado st; then
	msg "Removendo o st do pacote (o do repositorio substitui)"
	remover st || aviso "Nao removeu o pacote st (seguindo)"
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

# 4b. perfil da maquina: notebook (com bateria) ou desktop
PERFIL_DETECTADO=$(sh "$REPO/x11/bin/perfil-maquina" -d)
case "${PERFIL:-}" in
desktop|notebook) PERFIL_FINAL=$PERFIL ;;
'')               PERFIL_FINAL=$PERFIL_DETECTADO ;;
*)                aviso "PERFIL=$PERFIL invalido (use desktop ou notebook); usando o detectado"
                  PERFIL_FINAL=$PERFIL_DETECTADO ;;
esac
msg "Perfil da maquina: $PERFIL_FINAL (detectado: $PERFIL_DETECTADO)"
rodar mkdir -p "$HOME/.config/dwm-config"
if [ "$SIMULAR" -eq 1 ]; then
	printf '    [simulado] gravar "%s" em %s\n' "$PERFIL_FINAL" "$HOME/.config/dwm-config/perfil"
else
	echo "$PERFIL_FINAL" > "$HOME/.config/dwm-config/perfil"
fi

# 5. resumo
msg "Pronto."
[ -n "$falhas" ] && aviso "Pacotes opcionais que nao instalaram:$falhas"
[ "$SIMULAR" -eq 1 ] || command -v i3lock >/dev/null || \
	aviso "i3lock nao encontrado no PATH: Alt+Shift+x e o bloqueio automatico nao vao funcionar."
fc-list 2>/dev/null | grep -qi "cascadia code" || \
	aviso "Fonte Cascadia Code nao encontrada: coloque os .ttf em ~/.fonts e rode fc-cache."
[ -d "$BACKUP" ] && msg "Arquivos antigos guardados em $BACKUP"
msg "Saia da sessao atual e rode: startx"
