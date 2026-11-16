# Cores: amarelo Tango

O dwm usa a paleta **Tango**: amarelo Butter sobre Aluminium escuro, o mesmo visual do rice com cwm.

## A paleta Tango (o que o dwm usa)

| Nome Tango | Hex | Uso no dwm |
|---|---|---|
| Butter 2 | `#edd400` | **Destaque**: tag ativa, título e borda da janela com foco |
| Butter 1 | `#fce94f` | Destaque mais claro (alternativa) |
| Butter 3 | `#c4a000` | Destaque mais escuro (alternativa) |
| Aluminium 6 | `#2e3436` | Fundo da barra, texto sobre o destaque, fundo da tela |
| Aluminium 5 | `#555753` | Borda das janelas sem foco |
| Aluminium 2 | `#d3d7cf` | Texto da barra |

## dwm: `dwm/config.h`

```c
static const char col_gray1[] = "#2e3436"; /* fundo da barra          */
static const char col_gray2[] = "#555753"; /* borda da janela inativa */
static const char col_gray3[] = "#d3d7cf"; /* texto da barra          */
static const char col_gray4[] = "#2e3436"; /* texto sobre o destaque  */
static const char col_cyan[]  = "#edd400"; /* destaque: amarelo Tango */
```

Os nomes (`col_gray1`, `col_cyan`) vêm do dwm original. O nome não importa, o valor sim.

| Variável | Onde aparece |
|---|---|
| `col_gray1` | Fundo da barra e das tags inativas |
| `col_gray2` | Borda das janelas sem foco |
| `col_gray3` | Texto das tags inativas e do status |
| `col_gray4` | Texto da tag ativa e do título |
| `col_cyan` | Fundo da tag ativa, do título e borda da janela com foco |

O **dmenu** (pacote) recebe essas mesmas cores pelo `dmenucmd` do `config.h`, então abre em amarelo Tango pelo `Alt+p`.

Depois de mudar:

```sh
cd ~/dwm-config/dwm && make && doas make install
```

Saia do dwm (`Alt+Shift+q`) e rode `startx` de novo.

### Trocas rápidas de destaque

| Quer o destaque em | `col_cyan` |
|---|---|
| Amarelo Tango (atual) | `#edd400` |
| Amarelo claro | `#fce94f` |
| Amarelo escuro | `#c4a000` |
| Laranja Tango | `#f57900` |
| Azul Tango | `#3465a4` |
| Verde Tango | `#73d216` |

## Fundo da tela: `x11/.xinitrc`

```sh
xsetroot -solid "#2e3436"     # aparece se não houver ~/.fehbg
[ -f ~/.fehbg ] && sh ~/.fehbg
```

## Terminal: `st` e `x11/.Xresources`

O st e o `.Xresources` continuam em **Gruvbox** (`#282828` / `#ebdbb2`). O st deste repo lê o `.Xresources`
(patch xresources), então trocar as cores lá muda o st também:

```sh
xrdb -merge ~/.Xresources     # vale para os terminais abertos depois
```

## Testar uma cor antes

```sh
printf '\033[48;2;237;212;0m        \033[0m\n'   # mostra #edd400 (237,212,0 em decimal)
```
