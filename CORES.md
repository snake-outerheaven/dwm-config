# Cores: Gruvbox dark com destaque amarelo

O dwm usa a paleta **Gruvbox dark**: amarelo `#fabd2f` sobre o fundo `#282828`. O st, o dmenu e o dunst seguem a mesma paleta.

## A paleta (o que o dwm usa)

| Nome Gruvbox | Hex | Uso no dwm |
|---|---|---|
| bright yellow | `#fabd2f` | **Destaque**: tag ativa, título e borda da janela com foco |
| bg0 | `#282828` | Fundo da barra, texto sobre o destaque, fundo da tela |
| bg2 | `#504945` | Borda das janelas sem foco |
| fg1 | `#ebdbb2` | Texto da barra |

## dwm: `dwm/config.h`

```c
static const char col_gray1[] = "#282828"; /* fundo da barra          */
static const char col_gray2[] = "#504945"; /* borda da janela inativa */
static const char col_gray3[] = "#ebdbb2"; /* texto da barra          */
static const char col_gray4[] = "#282828"; /* texto sobre o destaque  */
static const char col_cyan[]  = "#fabd2f"; /* destaque: amarelo       */
```

Os nomes (`col_gray1`, `col_cyan`) vêm do dwm original. O nome não importa, o valor sim.

| Variável | Onde aparece |
|---|---|
| `col_gray1` | Fundo da barra e das tags inativas |
| `col_gray2` | Borda das janelas sem foco |
| `col_gray3` | Texto das tags inativas e do status |
| `col_gray4` | Texto da tag ativa e do título |
| `col_cyan` | Fundo da tag ativa, do título e borda da janela com foco |

O **dmenu** (pacote) recebe essas mesmas cores pelo `dmenucmd` do `config.h`, então abre em amarelo pelo `Alt+p`.

Depois de mudar:

```sh
cd ~/dwm-config/dwm && make && doas make install
```

Saia do dwm (`Alt+Shift+q`) e rode `startx` de novo.

### Trocas rápidas de destaque

| Quer o destaque em | `col_cyan` |
|---|---|
| Amarelo (atual) | `#fabd2f` |
| Amarelo escuro | `#d79921` |
| Laranja | `#fe8019` |
| Vermelho | `#cc241d` |
| Verde | `#b8bb26` |
| Azul | `#83a598` |
| Aqua | `#8ec07c` |

## Fundo da tela: `x11/.xinitrc`

```sh
xsetroot -solid "#282828"     # aparece se não houver ~/.fehbg
[ -f ~/.fehbg ] && sh ~/.fehbg
```

## Terminal: `st` e `share/Xresources`

O terminal usa a paleta Gruvbox dark completa: fundo `#282828`, texto `#ebdbb2`, cursor `#fabd2f`.

| Cor | Normal (0-7) | Clara (8-15) |
|---|---|---|
| Preto / cinza | `#282828` | `#928374` |
| Vermelho | `#cc241d` | `#fb4934` |
| Verde | `#98971a` | `#b8bb26` |
| Amarelo | `#d79921` | `#fabd2f` |
| Azul | `#458588` | `#83a598` |
| Roxo | `#b16286` | `#d3869b` |
| Ciano (aqua) | `#689d6a` | `#8ec07c` |
| Branco | `#a89984` | `#ebdbb2` |

As mesmas cores estão no `st/config.h` (padrão) e no `share/Xresources`, instalado em `/usr/local/share/dwm-config/Xresources` e carregado pelo `.xinitrc` (prioridade, pelo patch xresources). Um `~/.Xresources` seu, se existir, é carregado depois e ganha.

Para ajustar sem recompilar o st:

```sh
xrdb -merge ~/.Xresources     # vale para os terminais abertos depois
```

## Notificações: `share/dunstrc`

Fundo `#282828` em todas, barra de progresso `#fabd2f`.

| Urgência | Texto | Moldura |
|---|---|---|
| Baixa | `#a89984` | `#504945` |
| Normal | `#ebdbb2` | `#fabd2f` |
| Crítica | `#ebdbb2` | `#fb4934` (fica até você fechar) |

## Testar uma cor antes

```sh
printf '\033[48;2;250;189;47m        \033[0m\n'   # mostra #fabd2f (250,189,47 em decimal)
```

## Outros apps: GTK, zathura e CopyQ

| App | Arquivo em `share/` | Cores |
|---|---|---|
| GTK3 (Firefox, LibreOffice) | `xdg/gtk-3.0/settings.ini` | Adwaita escuro (`GTK_THEME=Adwaita:dark` no `.xinitrc`), ícones Papirus-Dark |
| GTK2 | `gtkrc-2.0` | Adwaita-dark |
| zathura | `xdg/zathurarc` | Fundo `#282828`, texto `#ebdbb2`, barra `#504945`, destaque `#fabd2f`; o PDF é recolorido (`Ctrl+r` volta ao original) |
| CopyQ | `copyq-gruvbox.ini` | Fundo `#282828`, seleção `#fabd2f`; aplicar uma vez com `copyq loadTheme /usr/local/share/dwm-config/copyq-gruvbox.ini` |
