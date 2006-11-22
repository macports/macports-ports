--- rts/Linker.c.sav	2006-11-21 12:58:37.000000000 -0500
+++ rts/Linker.c	2006-11-21 13:00:13.000000000 -0500
@@ -797,6 +797,7 @@
       RTS_POSIX_ONLY_SYMBOLS
       RTS_MINGW_ONLY_SYMBOLS
       RTS_CYGWIN_ONLY_SYMBOLS
+      RTS_DARWIN_ONLY_SYMBOLS
       RTS_LIBGCC_SYMBOLS
 #if defined(darwin_HOST_OS) && defined(i386_HOST_ARCH)
       // dyld stub code contains references to this,
