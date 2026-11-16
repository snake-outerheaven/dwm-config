# dwm-config no FreeBSD 15 (desktop com ZFS)

Guia para levar o puffy (ThinkPad T420) do OpenBSD para o **FreeBSD 15.1** com **ZFS**, e subir este mesmo dwm.
O repositório funciona nos dois sistemas: os `Makefile`, os scripts e o `.xinitrc` detectam o sistema sozinhos.

---

## 0. Antes de apagar o OpenBSD

| Item | Como |
|---|---|
| Configs | Já estão no GitHub (`dwm-config`, `my-dotfiles`) |
| Arquivos pessoais | Copie `~/Downloads`, `~/Documentos` etc. para o serv ou um pendrive |
| Chaves SSH | `~/.ssh/` para um pendrive |
| BIOS do T420 | Se o seu tiver placa NVIDIA (Optimus): *Config → Display → Graphics Device = Integrated Graphics* |

---

## 1. Baixar e gravar o pendrive (a partir do OpenBSD)

```sh
cd ~/Downloads
ftp https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/15.1/FreeBSD-15.1-RELEASE-amd64-memstick.img.xz
ftp https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/15.1/CHECKSUM.SHA256-FreeBSD-15.1-RELEASE-amd64
sha256 -C CHECKSUM.SHA256-FreeBSD-15.1-RELEASE-amd64 FreeBSD-15.1-RELEASE-amd64-memstick.img.xz
xz -d FreeBSD-15.1-RELEASE-amd64-memstick.img.xz
dmesg | tail                       # descubra o pendrive (ex.: sd2)
doas dd if=FreeBSD-15.1-RELEASE-amd64-memstick.img of=/dev/rsd2c bs=1m
```

---

## 2. Instalação (bsdinstall)

| Tela | Escolha |
|---|---|
| Keymap | O layout do seu teclado |
| Hostname | `puffy` |
| Instalação | **Distribution Sets** (o recomendado no 15.x; o pkgbase fica para antes do 16.0) |
| Componentes | Nenhum extra é necessário (`src` só se quiser ler o código do sistema) |
| Particionamento | **Auto (ZFS)** |
| ↳ Pool | `zroot`, tipo **stripe** (um disco) |
| ↳ Esquema | **GPT (BIOS+UEFI)** |
| ↳ Swap | 4g |
| ↳ Criptografia | Opcional: *Encrypt Disks* pede a senha a cada boot |
| Rede | `iwn0` (Wi-Fi Intel 6205), WPA, DHCP |
| Fuso | America/Sao_Paulo |
| Serviços | `ntpd`, `ntpd_sync_on_start`, `powerd`, `dumpdev`. **Não** marque `sshd` no desktop |
| Hardening | `hide_uids`, `hide_gids`, `random_pid`, `clear_tmp`, `disable_syslogd`, `secure_console` |
| Usuário | `neo`, com os grupos extras **`wheel video operator`** |

`wheel` = pode usar o doas · `video` = acesso à placa de vídeo · `operator` = desligar e suspender.

---

## 3. Primeiro boot

Como root:

```sh
pkg update
pkg install doas git xorg drm-kmod
echo 'permit :wheel' > /usr/local/etc/doas.conf
chmod 0640 /usr/local/etc/doas.conf
```

Configuração do sistema (o mesmo que está em `sistema/freebsd/rc.conf.trecho`):

```sh
sysrc kld_list+="i915kms acpi_ibm acpi_video"
sysrc dbus_enable=YES
sysrc powerd_enable=YES powerd_flags="-a hiadaptive -b adaptive"
echo 'hw.acpi.lid_switch_state=S3' >> /etc/sysctl.conf
reboot
```

---

## 4. Instalar o dwm-config

Como `neo`:

```sh
git clone https://github.com/snake-outerheaven/dwm-config ~/dwm-config
cd ~/dwm-config
sh install.sh -n     # simula
sh install.sh        # pacotes, compila dwm e st, aplica o x11 com stow
startx
```

O `install.sh` usa `pkg install` no FreeBSD e instala também `xautolock` e `dbus`.
`make` é o make do FreeBSD; os Makefiles são POSIX e não precisam de `gmake`.

---

## 5. Bloquear antes de suspender

Cole o conteúdo de `sistema/freebsd/rc.suspend.trecho` no `/etc/rc.suspend`, **antes** das linhas de `sync` e `sleep`:

```sh
doas vi /etc/rc.suspend
```

Teste: `doas acpiconf -s 3` (ou feche a tampa). Ao acordar, a tela já deve estar bloqueada.

---

## 6. O que muda em relação ao OpenBSD

| Função | OpenBSD | FreeBSD |
|---|---|---|
| Pacotes | `pkg_add`, `pkg_delete`, `pkg_info` | `pkg install`, `pkg delete`, `pkg info` |
| Serviços | `rcctl enable x` | `sysrc x_enable=YES`, `service x start` |
| Atualizar o sistema | `syspatch`, `sysupgrade` | `freebsd-update fetch install` |
| Atualizar pacotes | `pkg_add -u` | `pkg upgrade` |
| doas | Base, `/etc/doas.conf` | Pacote, `/usr/local/etc/doas.conf` |
| X | Xenocara em `/usr/X11R6` | Xorg em `/usr/local` |
| Volume | `sndioctl` | `mixer` |
| Brilho | `xbacklight` | `backlight` (base) |
| Bateria | `apm`, `hw.sensors` | `hw.acpi.battery.life`, `hw.acpi.acline` |
| Bloqueio por inatividade | `xidle` (base) | `xautolock` (pacote) |
| Antes de suspender | `/etc/apm/suspend` | `/etc/rc.suspend` |
| Suspender pela tampa | `machdep.lidaction` | `hw.acpi.lid_switch_state=S3` |
| Swallow do dwm | `kvm_getprocs` | `sysctl(KERN_PROC_PID)` |
| Disco | FFS | ZFS |

O `dwm-status`, o `midia` e o `.xinitrc` escolhem o comando certo com `case "$(uname -s)"`.

---

## 7. ZFS no dia a dia

| Quero... | Comando |
|---|---|
| Ponto de volta antes de mexer no sistema | `doas bectl create antes-de-X` |
| Listar os pontos de volta | `bectl list` |
| Voltar para um deles | `doas bectl activate antes-de-X` e reiniciar |
| Foto da home antes de algo arriscado | `doas zfs snapshot zroot/home@antes` |
| Desfazer a home inteira | `doas zfs rollback zroot/home@antes` |
| Recuperar um arquivo da foto | `ls ~/.zfs/snapshot/antes/` |
| Ver espaço | `zfs list` · `zpool list` |
| Saúde do disco | `zpool status` |

Rotina de atualização segura:

```sh
doas bectl create antes-$(date +%Y%m%d)
doas freebsd-update fetch install
doas pkg upgrade
```

---

## 8. Problemas comuns

| Sintoma | Verifique | Solução |
|---|---|---|
| `startx` dá tela preta ou erro de vídeo | `kldstat \| grep i915` | `sysrc kld_list+=i915kms`, `pkg install drm-kmod`, usuário no grupo `video` |
| Sem som | `cat /dev/sndstat` | `sysctl hw.snd.default_unit=N` com o número da placa certa |
| Brilho não muda | `backlight -i` | `acpi_video` e `i915kms` no `kld_list` |
| Wi-Fi não sobe | `dmesg \| grep iwn`, `sysctl net.wlan.devices` | Ajuste `wlans_iwn0` e `/etc/wpa_supplicant.conf` |
| dunst não mostra nada | `echo $DBUS_SESSION_BUS_ADDRESS` | `pkg install dbus`; o `.xinitrc` sobe a sessão D-Bus |
| Tampa não suspende | `sysctl hw.acpi.supported_sleep_state` | Deve listar `S3`; confira o `sysctl.conf` |
| Swallow não funciona | `dwm` compilado no FreeBSD? | `cd ~/dwm-config/dwm && make clean && make && doas make install` |
| Erro de `u_int` ao compilar o dwm | `config.mk` | O `-D__BSD_VISIBLE=1` já vem; confira se o `OS` saiu `FreeBSD` com `make -V OS` |

---

## Fontes

- FreeBSD 15.1-RELEASE: <https://www.freebsd.org/releases/15.1R/announce/>
- Atualizar no 15.x (freebsd-update e pkgbase): <https://wiki.freebsd.org/Upgrading>
- `mixer(8)`: <https://man.freebsd.org/mixer(8)>
- `backlight(8)`: <https://man.freebsd.org/backlight(8)>
- Bloquear o X antes de suspender: <https://forums.freebsd.org/threads/how-to-lock-x-before-going-to-sleep.90563/>
- dwm no FreeBSD 15 (caminhos e swallow): <https://forums.freebsd.org/threads/complete-suckless-desktop-dwm-st-dwmblocks-picom-on-freebsd-15-porting-guide-from-linux.102409/>
