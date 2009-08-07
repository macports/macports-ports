--- config.mk.orig	2007-12-02 20:20:56.000000000 +0100
+++ config.mk	2007-12-02 20:26:25.000000000 +0100
@@ -8,18 +8,18 @@
 LAYOUTS = layouts/tile.c layouts/floating.c layouts/max.c
 
 # paths
-PREFIX = /usr/local
+PREFIX = /opt/local
 MANPREFIX = ${PREFIX}/share/man
 
-X11INC = /usr/include/X11
-X11LIB = /usr/lib/X11
+X11INC = /opt/local/include/X11
+X11LIB = /opt/local/lib
 
 # includes and libs
-INCS = -I. -I/usr/include -I${X11INC} `pkg-config --cflags libconfuse xft cairo`
-LIBS = -L/usr/lib -lc -L${X11LIB} -lX11 `pkg-config --libs libconfuse xft cairo` -lXext -lXrandr -lXinerama
+INCS = -I. -I/opt/local/include -I${X11INC} `pkg-config --cflags libconfuse xft cairo`
+LIBS = -L/opt/local/lib -lc -L${X11LIB} -lX11 `pkg-config --libs libconfuse xft cairo` -lXext -lXrandr -lXinerama
 
 # flags
-CFLAGS = -fgnu89-inline -std=gnu99 -ggdb3 -pipe -Wall -Wextra -W -Wchar-subscripts -Wundef -Wshadow -Wcast-align -Wwrite-strings -Wsign-compare -Wunused -Wuninitialized -Winit-self -Wpointer-arith -Wredundant-decls -Wno-format-zero-length -Wmissing-prototypes -Wmissing-format-attribute -Wmissing-noreturn -O3 ${INCS} -DVERSION=\"${VERSION}\" -DRELEASE=\"${RELEASE}\"
+CFLAGS = -std=gnu99 -ggdb3 -pipe -Wall -Wextra -W -Wchar-subscripts -Wundef -Wshadow -Wcast-align -Wwrite-strings -Wsign-compare -Wunused -Wuninitialized -Winit-self -Wpointer-arith -Wredundant-decls -Wno-format-zero-length -Wmissing-prototypes -Wmissing-format-attribute -Wmissing-noreturn -O3 ${INCS} -DVERSION=\"${VERSION}\" -DRELEASE=\"${RELEASE}\"
 LDFLAGS = -ggdb3 ${LIBS}
 CLIENTLDFLAGS = -ggdb3
 
