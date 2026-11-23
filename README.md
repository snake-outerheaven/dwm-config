# dwm-config

dwm 6.4 para FreeBSD, em Gruvbox com destaque vermelho (`#cc241d` sobre `#282828`),
fonte Cascadia Code e áreas de trabalho em algarismos romanos (I a IX).

![dwm-config](docs/dwm.png)

> Branch `freebsd`. A versão para OpenBSD fica na `master`.

## Conteúdo

| Pasta / arquivo | O que é |
|---|---|
| `dwm/` | Código-fonte do dwm 6.4 com o `config.h` pronto. **Não é pacote do stow**: compila e instala |
| `st/` | st 0.9.3 (base [st-flexipatch](https://github.com/bakkeby/st-flexipatch)) com jeito de alacritty. Compila e instala |
| `install.sh` | Na raiz: instala pacotes, compila dwm e st, instala scripts e arquivos no sistema e aplica o `x11` com o stow |
| `x11/` | Pacote do stow: só `.xinitrc` e `.xsession`. São os únicos arquivos que o setup põe no `$HOME` |
| `scripts/` | `dwm-status`, `printar`, `midia`, `perfil-maquina`. Instalados em `/usr/local/libexec/dwm-config/`, **nunca** no seu `~/bin` |
| `share/` | `Xresources` e `dunstrc`, instalados em `/usr/local/share/dwm-config/` |
| `patches/` | Os diffs aplicados no dwm e no st, para reaplicar numa árvore limpa |
| `CORES.md` | Guia de todas as cores, para mexer sozinho |
| `dwm/movestack.c`, `dwm/vanitygaps.c` | Código trazido pelos patches |
| `LICENSE` | MIT/X, a mesma licença do dwm |

## Instalação

```sh
git clone https://github.com/snake-outerheaven/dwm-config ~/dwm-config
cd ~/dwm-config
sh install.sh -n     # simulação: mostra o que faria
sh install.sh        # instala de verdade
startx
```

O `install.sh` instala os pacotes essenciais (`dmenu`, `stow`, `i3lock`), compila o `st` do repositório e os opcionais
(`git`, `vim`, `fastfetch`, `cascadia-code`, `feh`, `scrot`, `xdg-user-dirs`, `dunst`, `libnotify`, `copyq`, `ranger`, `firefox`), compila e instala o dwm, instala os scripts em
`/usr/local/libexec/dwm-config/`, grava o perfil em `/etc/dwm-config/perfil` e aplica o pacote `x11` com o stow. Arquivos que já existirem no `$HOME` vão para
`~/.dotfiles-backup-DATA`; nada é apagado.

### Grupos de programas extras

Além dos opcionais acima, o `install.sh` instala três grupos. Todos vêm ligados; escolha com a variável `GRUPOS`:

| Grupo | Pacotes |
|---|---|
| `escritorio` | `libreoffice`, `libreoffice-i18n-pt-br`, `zathura`, `zathura-pdf-mupdf` |
| `midia` | `mpv` |
| `dev` | `clang-tools-extra` (`clangd`, `clang-tidy`, `clang-format`) |

```sh
GRUPOS="dev midia" sh install.sh   # só esses dois grupos
GRUPOS="" sh install.sh            # nenhum (o LibreOffice é pesado)
```

À mão:

```sh
sudo pkg delete -y dwm               # se o dwm do pacote estiver instalado
cd dwm && make && sudo make install
sudo pkg delete -y st                # se o st do pacote estiver instalado
cd ../st && make && sudo make install
cd ..
sudo install -d /usr/local/libexec/dwm-config /usr/local/share/dwm-config /etc/dwm-config
sudo install -m 755 scripts/* /usr/local/libexec/dwm-config/
sudo install -m 644 share/* /usr/local/share/dwm-config/
stow --no-folding x11                # só ~/.xinitrc e ~/.xsession
startx
```

O `config.mk` detecta o sistema pelo `uname -s`: no FreeBSD, o X e o freetype ficam em `/usr/local` (`/usr/local/include/freetype2`). O `install.sh` usa o `doas` se ele estiver configurado, senão o `sudo`.

### make do BSD ou GNU make

Os `Makefile` de `dwm/` e `st/` usam só sintaxe POSIX (`.POSIX:`), então
funcionam com o `make(1)` dos BSDs (o bmake) e com o `gmake`. Testado com GNU make e
bmake: `all`, `install`, `clean` e `dist`.

```sh
make && sudo make install          # make do FreeBSD
gmake && sudo gmake install        # GNU make
```

Em outro sistema, troque os caminhos na linha de comando (vale para os dois):

```sh
make X11INC=/usr/include X11LIB=/usr/lib FREETYPEINC=/usr/include/freetype2 KVMLIB=
```

## Patches aplicados

| Patch | Origem | O que muda |
|---|---|---|
| pertag | 6.4 | Cada área (I a IX) guarda o próprio layout, mfact e nmaster |
| vanitygaps | 6.4 | Espaço entre janelas e bordas; 13 layouts extras |
| attachbottom | 6.3, ajustado | Janela nova entra no fim da pilha, sem roubar a área principal |
| swallow | 6.3, ajustado | Programa gráfico aberto pelo `st` toma o lugar do terminal |
| togglefullscreen | 6.3 | Tela cheia em qualquer janela |
| hide_vacant_tags | à mão | A barra só mostra áreas ocupadas ou a atual |
| movestack | à mão | Move a janela para cima ou para baixo na pilha |
| scratchpad | à mão | Um st flutuante que aparece e some com ``Alt+` `` |
| autostart | à mão | O dwm sobe os programas da sessão (`autostart[]` no `config.h`) e os encerra ao sair |

Diffs de referência: coleção [bakkeby/patches](https://github.com/bakkeby/patches)
(o site suckless.org tem as versões oficiais de cada um).

O swallow acha o PID da janela pela propriedade `_NET_WM_PID` e o processo pai pelo
`sysctl(3)` (`kern.proc.pid`, campo `ki_ppid`), sem biblioteca extra. No OpenBSD o
mesmo trecho usa o `kvm_getprocs(3)`.
Para desligar o swallow numa janela, use `noswallow = 1` na regra dela.

## st (terminal)

![st no dwm](docs/st.png)

O dmenu fica como vem. O st foi ajustado para lembrar o alacritty:

| Recurso | Como usar |
|---|---|
| Histórico de 10 000 linhas | Roda do mouse, ou `Shift+PageUp` / `Shift+PageDown` |
| Reflow: o texto se reorganiza ao redimensionar | Automático |
| Copiar / colar | `Ctrl+Shift+c` / `Ctrl+Shift+v` (seleção vai direto para o clipboard) |
| Zoom da fonte | `Ctrl+=` / `Ctrl+-` / `Ctrl+0` |
| Modo vi (selecionar com o teclado) | `Ctrl+Shift+Espaço` ou `Ctrl+Shift+Esc` |
| Busca | `Ctrl+Shift+f` / `Ctrl+Shift+b` |
| Linhas e caixas desenhadas pelo st | Automático (boxdraw) |
| Cores Gruvbox (cursor vermelho `#cc241d`) | Do `config.h` e de `/usr/local/share/dwm-config/Xresources`; um `~/.Xresources` seu, se existir, tem prioridade |

Patches ligados em `st/patches.h`: reflow, scrollback (+ mouse), clipboard,
keyboard_select, boxdraw, anysize e xresources. Para ligar ou desligar outro,
mude o `0`/`1` lá e recompile (`cd st && make && sudo make install`).

## Wallpaper

O `.xinitrc` roda o `~/.fehbg` a cada sessão. Para escolher a imagem:

```sh
feh --bg-fill ~/flores.jpg    # mostra agora e grava o ~/.fehbg
```

Sem `~/.fehbg`, fica o fundo sólido `#282828`.

## Barra

O `dwm-status` (em `/usr/local/libexec/dwm-config/`) escreve na barra a cada 5 s: cpu (`kern.cp_time`), memória ativa
(`vm.stats.vm.v_active_count`), volume (`mixer -o`), bateria (`hw.acpi.battery.life` e `hw.acpi.acline`) e data.
O dwm sobe o script sozinho (autostart) e o encerra ao sair.

```sh
/usr/local/libexec/dwm-config/dwm-status -1    # imprime a linha uma vez, para testar
```

### Notebook ou desktop

O mesmo setup serve para os dois. O `install.sh` detecta se a máquina tem bateria
(`hw.acpi.battery.units` e carga de 1 a 100%) e grava o perfil em `/etc/dwm-config/perfil`:

| Perfil | Barra | Avisos de bateria |
|---|---|---|
| `notebook` | `cpu \| mem \| vol \| bat \| data` | Em 15% e 5% |
| `desktop` | `cpu \| mem \| vol \| data` | Nenhum |

```sh
/usr/local/libexec/dwm-config/perfil-maquina      # mostra o perfil em uso
/usr/local/libexec/dwm-config/perfil-maquina -d   # mostra só o que o hardware indica
PERFIL=desktop sh install.sh      # força o perfil na instalação
echo desktop | sudo tee /etc/dwm-config/perfil    # ou troca à mão; vale no próximo startx
```

## Atalhos (Mod = Alt)

| Atalho | Ação |
|---|---|
| `Alt+Shift+Enter` | Terminal (`st`) |
| ``Alt+` `` | Scratchpad: st flutuante que aparece e some |
| `Alt+p` | dmenu |
| `Alt+w` | Firefox |
| `Alt+e` | ranger (arquivos) no st |
| `Alt+v` | Histórico do clipboard (copyq) |
| `Alt+j` / `Alt+k` | Próxima / anterior janela |
| `Alt+Shift+j` / `Alt+Shift+k` | Move a janela na pilha (movestack) |
| `Alt+h` / `Alt+l` | Diminui / aumenta a área principal |
| `Alt+Enter` | Manda a janela para a área principal |
| `Alt+t` / `Alt+f` / `Alt+m` | Layout tile / flutuante / monocle |
| `Alt+y` | Tela cheia na janela atual |
| `Alt+Super+0` / `Alt+Super+Shift+0` | Liga/desliga os gaps / volta ao padrão |
| `Alt+Super+u` / `Alt+Super+Shift+u` | Aumenta / diminui todos os gaps |
| `Alt+1..9` / `Alt+Shift+1..9` | Ir para a área / mandar janela |
| `Print` / `Alt+Print` | Print da tela / de uma área, em `~/Downloads` |
| `Alt+Shift+x` | Bloqueia a tela (`i3lock`) |
| Teclas de volume / brilho | `mixer` / `backlight`, com o valor novo no dunst |
| `Alt+Shift+c` | Fecha a janela |
| `Alt+Shift+q` | Sai do dwm |

## Desktop

O que o **próprio dwm** sobe ao iniciar e encerra ao sair (`autostart[]` no `dwm/config.h`):

| Peça | Para quê |
|---|---|
| `dwm-status` | Barra: cpu, memória, volume, bateria e data; avisa a bateria em 15% e 5% |
| `dunst -config /usr/local/share/dwm-config/dunstrc` | Notificações em Gruvbox, com moldura vermelha (print salvo, volume, brilho, bateria, programas) |
| `copyq` | Histórico do clipboard (`Alt+v`) |
| `xautolock` (pacote) | Chama o `i3lock` após 5 min parado (`xautolock -locknow` bloqueia na hora) |

Bloquear antes de suspender (tampa ou `zzz`) ainda não está automatizado no FreeBSD.
Por enquanto: `xautolock -locknow && sleep 1 && zzz`.

Regras de janela: nenhuma por programa. Só o `st` é marcado como terminal (o swallow precisa).

## Mudar algo

O dwm não tem arquivo de configuração em tempo de execução: edite `dwm/config.h`
e recompile.

```sh
cd ~/dwm-config/dwm && make && sudo make install
```

Saia do dwm (`Alt+Shift+q`) e rode `startx` de novo. As cores estão explicadas em `CORES.md`.

## Referências

`dwm(1)`, `dmenu(1)`, `st(1)`, `xsetroot(1)`, `mixer(8)`, `backlight(8)`, `acpi_battery(4)`, `stow(8)`.
