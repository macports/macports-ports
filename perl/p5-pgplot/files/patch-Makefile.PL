--- Makefile.PL.orig	Fri Dec 15 14:00:32 2000
+++ Makefile.PL	Tue May 18 16:39:48 2004
@@ -32,7 +32,7 @@
         'LIBS'	=> ['-L/usr/openwin/lib -L/usr/X11/lib -L/usr/X11R6/lib -lX11 '.
                     ExtUtils::F77->runtime])
        :
-         ('LIBS' => [$ldir.' -L/usr/local/pgplot -L/usr/local/lib -lcpgplot -lpgplot '.
+         ('LIBS' => [$ldir.' -L/usr/local/pgplot -L/usr/local/lib -lcpgplot -lpgplot -lpng -lz '.
                     '-L/usr/openwin/lib -L/usr/X11/lib -L/usr/X11R6/lib -lX11 '.
                     ExtUtils::F77->runtime])
      )),
