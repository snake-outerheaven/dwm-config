# st version
VERSION = 0.9.3

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man
ICONPREFIX = $(PREFIX)/share/pixmaps
ICONNAME = st.png

# Sistema detectado sozinho (FreeBSD; OpenBSD e Linux tambem); troque na linha de comando se precisar
OS != uname -s
X11INC_FreeBSD = /usr/local/include
X11LIB_FreeBSD = /usr/local/lib
X11INC_OpenBSD = /usr/X11R6/include
X11LIB_OpenBSD = /usr/X11R6/lib
X11INC_Linux   = /usr/include
X11LIB_Linux   = /usr/lib
X11INC = $(X11INC_$(OS))
X11LIB = $(X11LIB_$(OS))

PKG_CONFIG = pkg-config

# Uncomment this for the alpha patch / ALPHA_PATCH
#XRENDER = `$(PKG_CONFIG) --libs xrender`

# Uncomment this for the themed cursor patch / THEMED_CURSOR_PATCH
#XCURSOR = `$(PKG_CONFIG) --libs xcursor`

# Uncomment the lines below for the ligatures patch / LIGATURES_PATCH
#LIGATURES_C = hb.c
#LIGATURES_H = hb.h
#LIGATURES_INC = `$(PKG_CONFIG) --cflags harfbuzz`
#LIGATURES_LIBS = `$(PKG_CONFIG) --libs harfbuzz`

# Uncomment this for the SIXEL patch / SIXEL_PATCH
#SIXEL_C = sixel.c sixel_hls.c
#SIXEL_LIBS = `$(PKG_CONFIG) --libs imlib2`

# Uncomment for the netwmicon patch / NETWMICON_PATCH
#NETWMICON_LIBS = `$(PKG_CONFIG) --libs gdlib`

# includes and libs, uncomment harfbuzz for the ligatures patch
INCS = -I$(X11INC) \
       `$(PKG_CONFIG) --cflags fontconfig` \
       `$(PKG_CONFIG) --cflags freetype2` \
       $(LIGATURES_INC)
LIBS = -L$(X11LIB) -lm -lX11 -lutil -lXft ${SIXEL_LIBS} ${XRENDER} ${XCURSOR}\
       `$(PKG_CONFIG) --libs fontconfig` \
       `$(PKG_CONFIG) --libs freetype2` \
       $(LIGATURES_LIBS) \
       $(NETWMICON_LIBS)

# flags
# FreeBSD: o _XOPEN_SOURCE esconde as extensoes BSD dos headers; o __BSD_VISIBLE as traz de volta
BSDVIS_FreeBSD = -D__BSD_VISIBLE=1
STCPPFLAGS = -DVERSION=\"$(VERSION)\" -DICON=\"$(ICONPREFIX)/$(ICONNAME)\" -D_XOPEN_SOURCE=600 $(BSDVIS_$(OS))
STCFLAGS = $(INCS) $(STCPPFLAGS) $(CPPFLAGS) $(CFLAGS)
STLDFLAGS = $(LIBS) $(LDFLAGS)

# OpenBSD instala as manpages em $(PREFIX)/man; FreeBSD e Linux em share/man
MANPREFIX_FreeBSD = $(PREFIX)/share/man
MANPREFIX_OpenBSD = $(PREFIX)/man
MANPREFIX_Linux   = $(PREFIX)/share/man
MANPREFIX = $(MANPREFIX_$(OS))

# compiler and linker
# CC = c99
