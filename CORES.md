# Cores: Gruvbox com destaque vermelho

O dwm usa a paleta **Gruvbox escura**, com o vermelho como destaque: combina com o vermelho do FreeBSD.

## A paleta (o que o dwm usa)

| Nome Gruvbox | Hex | Uso no dwm |
|---|---|---|
| red | `#cc241d` | **Destaque**: tag ativa, título e borda da janela com foco |
| bright red | `#fb4934` | Destaque mais claro (alternativa) |
| bg0 | `#282828` | Fundo da barra e da tela |
| bg2 | `#504945` | Borda das janelas sem foco |
| fg | `#ebdbb2` | Texto da barra |
| fg0 | `#fbf1c7` | Texto sobre o destaque vermelho |

## dwm: `dwm/config.h`

```c
static const char col_gray1[] = "#282828"; /* fundo da barra          */
static const char col_gray2[] = "#504945"; /* borda da janela inativa */
static const char col_gray3[] = "#ebdbb2"; /* texto da barra          */
static const char col_gray4[] = "#fbf1c7"; /* texto sobre o destaque  */
static const char col_cyan[]  = "#cc241d"; /* destaque: vermelho      */
```

Os nomes (`col_gray1`, `col_cyan`) vêm do dwm original. O nome não importa, o valor sim.

| Variável | Onde aparece |
|---|---|
| `col_gray1` | Fundo da barra e das tags inativas |
| `col_gray2` | Borda das janelas sem foco |
| `col_gray3` | Texto das tags inativas e do status |
| `col_gray4` | Texto da tag ativa e do título |
| `col_cyan` | Fundo da tag ativa, do título e borda da janela com foco |

O **dmenu** (pacote) recebe essas mesmas cores pelo `dmenucmd` do `config.h`, então abre com a seleção em vermelho pelo `Alt+p`.

Depois de mudar:

```sh
cd ~/dwm-config/dwm && make && sudo make install
```

Saia do dwm (`Alt+Shift+q`) e rode `startx` de novo.

### Trocas rápidas de destaque (todas da Gruvbox)

| Quer o destaque em | `col_cyan` |
|---|---|
| Vermelho (atual) | `#cc241d` |
| Vermelho claro | `#fb4934` |
| Laranja | `#d65d0e` |
| Amarelo | `#d79921` |
| Verde | `#98971a` |
| Azul | `#458588` |
| Aqua | `#689d6a` |

## Fundo da tela: `x11/.xinitrc`

```sh
xsetroot -solid "#282828"     # aparece se não houver ~/.fehbg
[ -f ~/.fehbg ] && sh ~/.fehbg
```

## Terminal: `st` e `share/Xresources`

O terminal usa a Gruvbox completa: fundo `#282828`, texto `#ebdbb2`, cursor `#cc241d`.

| Cor | Normal (0-7) | Clara (8-15) |
|---|---|---|
| Preto / cinza | `#282828` | `#928374` |
| Vermelho | `#cc241d` | `#fb4934` |
| Verde | `#98971a` | `#b8bb26` |
| Amarelo | `#d79921` | `#fabd2f` |
| Azul | `#458588` | `#83a598` |
| Roxo | `#b16286` | `#d3869b` |
| Aqua | `#689d6a` | `#8ec07c` |
| Branco | `#a89984` | `#fbf1c7` |

As mesmas cores estão no `st/config.h` (padrão) e no `Xresources` (prioridade, pelo patch xresources).
Para ajustar sem recompilar o st, mude o `~/.Xresources`:

```sh
xrdb -merge ~/.Xresources     # vale para os terminais abertos depois
```

## Testar uma cor antes

```sh
printf '\033[48;2;204;36;29m        \033[0m\n'   # mostra #cc241d (204,36,29 em decimal)
```
