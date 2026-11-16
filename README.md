# dwm-config

dwm 6.4 para OpenBSD, em Gruvbox escuro com destaque amarelo apagado (`#b57614`),
fonte Cascadia Code e áreas de trabalho em algarismos romanos (I a IX).

![dwm-config no OpenBSD](docs/dwm.png)

## Conteúdo

| Pasta / arquivo | O que é |
|---|---|
| `dwm/` | Código-fonte do dwm 6.4 com o `config.h` pronto. **Não é pacote do stow**: compila e instala |
| `dwm/install.sh` | Instala pacotes, compila o dwm e aplica o `x11` com o stow |
| `x11/` | Pacote do stow: `.xinitrc`, `.xsession` (xenodm), `.Xresources` e `bin/dwm-status` |
| `CORES.md` | Guia de todas as cores, para mexer sozinho |
| `LICENSE` | MIT/X, a mesma licença do dwm |

## Instalação

```sh
git clone https://github.com/snake-outerheaven/dwm-config ~/dwm-config
cd ~/dwm-config/dwm
sh install.sh -n     # simulação: mostra o que faria
sh install.sh        # instala de verdade
startx
```

O `install.sh` instala os pacotes essenciais (`dmenu`, `st`, `stow`) e os opcionais
(`git`, `vim`, `fastfetch`, `cascadia-code`), compila e instala o dwm e aplica o
pacote `x11` com o stow. Arquivos que já existirem no `$HOME` vão para
`~/.dotfiles-backup-DATA`; nada é apagado.

À mão:

```sh
doas pkg_delete dwm                  # se o dwm do pacote estiver instalado
cd dwm && make && doas make install
cd .. && stow --no-folding x11       # ~/.xinitrc, ~/.xsession, ~/.Xresources, ~/bin/dwm-status
startx
```

O `config.mk` já usa os caminhos do OpenBSD (`${X11INC}/freetype2`).

## Barra

O `~/bin/dwm-status` escreve na barra a cada 5 s: volume (`sndioctl`), bateria
(`apm`, ou os sensores ACPI quando o `apm` não responde) e data.
O `~/bin` é o lugar padrão do OpenBSD para scripts do usuário.

```sh
dwm-status -1        # imprime a linha uma vez, para testar
```

## Atalhos (Mod = Alt)

| Atalho | Ação |
|---|---|
| `Alt+Shift+Enter` | Terminal (`st`) |
| `Alt+p` | dmenu |
| `Alt+j` / `Alt+k` | Próxima / anterior janela |
| `Alt+h` / `Alt+l` | Diminui / aumenta a área principal |
| `Alt+Enter` | Manda a janela para a área principal |
| `Alt+t` / `Alt+f` / `Alt+m` | Layout tile / flutuante / monocle |
| `Alt+1..9` / `Alt+Shift+1..9` | Ir para a área / mandar janela |
| `Alt+Shift+c` | Fecha a janela |
| `Alt+Shift+q` | Sai do dwm |

## Mudar algo

O dwm não tem arquivo de configuração em tempo de execução: edite `dwm/config.h`
e recompile.

```sh
cd ~/dwm-config/dwm && make && doas make install
```

Saia do dwm (`Alt+Shift+q`) e rode `startx` de novo. As cores estão explicadas em `CORES.md`.

## Referências

`dwm(1)`, `dmenu(1)`, `st(1)`, `xsetroot(1)`, `sndioctl(1)`, `apm(8)`, `stow(8)`.
