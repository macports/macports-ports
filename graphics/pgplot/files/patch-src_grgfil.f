--- ../src/grgfil.f.orig	Tue Jun 13 19:23:31 1995
+++ ../src/grgfil.f	Tue May 18 16:37:57 2004
@@ -26,7 +26,7 @@
 C  2-Dec-1994 - new routine [TJP].
 C-----------------------------------------------------------------------
       CHARACTER*(*) DEFDIR, DEFFNT, DEFRGB
-      PARAMETER  (DEFDIR='/usr/local/pgplot/')
+      PARAMETER  (DEFDIR='@@PREFIX@@/share/pgplot/')
       PARAMETER  (DEFFNT='grfont.dat')
       PARAMETER  (DEFRGB='rgb.txt')
       CHARACTER*255 FF
