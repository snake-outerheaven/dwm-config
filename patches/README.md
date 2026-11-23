# patches

Os diffs que transformam o código de origem nas árvores `dwm/` e `st/` deste repositório.

## dwm 6.4

| Arquivo | O que é |
|---|---|
| `dwm/dwm-neo-6.4.diff` | **Tudo junto**: dwm 6.4 → árvore `dwm/` atual (sem o `config.h`) |
| `dwm/dwm-pertag-6.4.diff` | pertag original |
| `dwm/dwm-vanitygaps-6.4.diff` | vanitygaps original |
| `dwm/dwm-attachbottom-6.3.diff` | attachbottom original (1 hunk ajustado à mão) |
| `dwm/dwm-swallow-6.3.diff` | swallow original (3 hunks ajustados à mão) |
| `dwm/dwm-togglefullscreen-6.3.diff` | togglefullscreen original |
| `dwm/dwm-systray-6.3.diff` | systray (versão do bakkeby/patches); 3 hunks de `dwm.c` refeitos à mão (protótipos e `destroynotify`, por causa do swallow) e as 4 opções no `config.h` |
| `dwm/dwm-cyclelayouts-6.3.diff` | cyclelayouts (bakkeby/patches); teclas `Alt+Ctrl+,` e `Alt+Ctrl+.` no `config.h` |

hide_vacant_tags, movestack, scratchpad e autostart foram escritos à mão; estão só no diff combinado.
O diff combinado ainda **não** inclui systray e cyclelayouts: aplique os dois por cima dele.

```sh
# reaplicar num dwm 6.4 limpo
cd dwm-6.4 && patch -p1 < ../patches/dwm/dwm-neo-6.4.diff
cp config.def.h config.h    # depois ajuste fonte, cores e tags (ver CORES.md)
```

## st 0.9.3

Base: [st-flexipatch](https://github.com/bakkeby/st-flexipatch), commit `9c733c4`.

| Arquivo | O que é |
|---|---|
| `st/st-neo-flexipatch-9c733c4.diff` | `patches.h` ligado, Tango, Cascadia Code, zoom do alacritty, histórico de 10 000 linhas |

```sh
git clone https://github.com/bakkeby/st-flexipatch && cd st-flexipatch
git checkout 9c733c4 && cp patches.def.h patches.h
patch -p1 < ../patches/st/st-neo-flexipatch-9c733c4.diff
```

Os dois diffs foram conferidos: aplicados na base, reproduzem as árvores do repositório.
