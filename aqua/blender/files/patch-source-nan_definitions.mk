--- source/nan_definitions.mk	Mon Feb  9 00:18:12 2004
+++ ../../blender/source/nan_definitions.mk	Mon Feb  9 00:17:48 2004
@@ -75,11 +75,6 @@
     export NAN_GHOST ?= $(LCGDIR)/ghost
     export NAN_TEST_VERBOSITY ?= 1
     export NAN_BMFONT ?= $(LCGDIR)/bmfont
-    ifeq ($(FREE_WINDOWS), true)
-      export NAN_FTGL ?= $(LCGDIR)/gcc/ftgl
-    else
-      export NAN_FTGL ?= $(LCGDIR)/ftgl
-    endif
 
   # Platform Dependent settings go below:
 
@@ -128,23 +123,24 @@
 
     export ID = $(shell whoami)
     export HOST = $(shell hostname -s)
-    export NAN_PYTHON ?= /sw
+    export NAN_PYTHON ?= ${prefix}
     export NAN_PYTHON_VERSION ?= 2.2
     export NAN_PYTHON_BINARY ?= $(NAN_PYTHON)/bin/python$(NAN_PYTHON_VERSION)
     export NAN_OPENAL ?= $(LCGDIR)/openal
     export NAN_FMOD ?= $(LCGDIR)/fmod
-    export NAN_JPEG ?= /sw
-    export NAN_PNG ?= /sw
+    export NAN_JPEG ?= ${prefix}
+    export NAN_PNG ?= ${prefix}
     export NAN_ODE ?= $(LCGDIR)/ode
     export NAN_TERRAPLAY ?= $(LCGDIR)/terraplay
     export NAN_MESA ?= /usr/src/Mesa-3.1
     export NAN_ZLIB ?= $(LCGDIR)/zlib
     export NAN_NSPR ?= $(LCGDIR)/nspr
-    export NAN_FREETYPE ?= /sw
-    export NAN_GETTEXT ?= $(LCGDIR)/gettext
+    export NAN_FREETYPE ?= ${prefix}
+    export NAN_GETTEXT ?= ${prefix}
     export NAN_SDL ?= $(LCGDIR)/sdl
-    export NAN_SDLCFLAGS ?= -I$(NAN_SDL)/include
-    export NAN_SDLLIBS ?= $(NAN_SDL)/lib/libSDL.a -framework Cocoa
+    export NAN_SDLCFLAGS ?= -I${prefix}/include/SDL
+    export NAN_SDLLIBS ?= ${prefix}/lib/libSDL.a -framework Cocoa -framework OpenGL -framework IOKit -liconv
+    export NAN_FTGL ?= ${prefix}
 
     # Uncomment the following line to use Mozilla inplace of netscape
     # CPPFLAGS +=-DMOZ_NOT_NET
