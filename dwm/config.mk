# dwm version
VERSION = 6.4

# Customize below to fit your system

# Sistema: FreeBSD (OpenBSD e Linux tambem compilam), detectado sozinho.
# "!=" e variaveis aninhadas funcionam no make do FreeBSD, do OpenBSD e no GNU make.
# Qualquer valor pode ser trocado na linha de comando: make X11INC=/outro/caminho
OS != uname -s

# paths
PREFIX = /usr/local

X11INC_FreeBSD = /usr/local/include
X11LIB_FreeBSD = /usr/local/lib
X11INC_OpenBSD = /usr/X11R6/include
X11LIB_OpenBSD = /usr/X11R6/lib
X11INC_Linux   = /usr/include
X11LIB_Linux   = /usr/lib
X11INC = ${X11INC_${OS}}
X11LIB = ${X11LIB_${OS}}

MANPREFIX_FreeBSD = ${PREFIX}/share/man
MANPREFIX_OpenBSD = ${PREFIX}/man
MANPREFIX_Linux   = ${PREFIX}/share/man
MANPREFIX = ${MANPREFIX_${OS}}

# Xinerama, comment if you don't want it
XINERAMALIBS  = -lXinerama
XINERAMAFLAGS = -DXINERAMA

# freetype
FREETYPELIBS = -lfontconfig -lXft
FREETYPEINC_FreeBSD = ${X11INC}/freetype2
FREETYPEINC_OpenBSD = ${X11INC}/freetype2
FREETYPEINC_Linux   = /usr/include/freetype2
FREETYPEINC = ${FREETYPEINC_${OS}}

# swallow: o OpenBSD acha o processo pai pelo kvm(3); o FreeBSD, pelo sysctl(3), sem biblioteca extra
KVMLIB_OpenBSD = -lkvm
KVMLIB = ${KVMLIB_${OS}}
XCBLIBS = -lX11-xcb -lxcb -lxcb-res


# includes and libs
INCS = -I${X11INC} -I${FREETYPEINC}
LIBS = -L${X11LIB} -lX11 ${XINERAMALIBS} ${FREETYPELIBS} ${XCBLIBS} ${KVMLIB}

# flags
# FreeBSD: com _POSIX_C_SOURCE definido, os headers escondem o que o swallow precisa
# (o sys/user.h usa o stack_t, que so aparece com as extensoes XSI e BSD). Sem a macro,
# o FreeBSD mostra tudo, que e o padrao dele; os outros sistemas continuam com ela.
POSIXFLAG_OpenBSD = -D_POSIX_C_SOURCE=200809L
POSIXFLAG_Linux   = -D_POSIX_C_SOURCE=200809L
POSIXFLAG_FreeBSD =
CPPFLAGS = -D_DEFAULT_SOURCE -D_BSD_SOURCE ${POSIXFLAG_${OS}} -DVERSION=\"${VERSION}\" ${XINERAMAFLAGS}
#CFLAGS   = -g -std=c99 -pedantic -Wall -O0 ${INCS} ${CPPFLAGS}
CFLAGS   = -std=c99 -pedantic -Wall -Wno-deprecated-declarations -Os ${INCS} ${CPPFLAGS}
LDFLAGS  = ${LIBS}

# Solaris
#CFLAGS = -fast ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = ${LIBS}

# compiler and linker
CC = cc
