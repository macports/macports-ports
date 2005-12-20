--- Gnuplot.h	1999-11-05 01:03:48.000000000 +0100
+++ Gnuplot.h	2005-12-18 14:43:09.000000000 +0100
@@ -181,7 +181,6 @@
 double log_base_log_y = 0.0;
 double log_base_log_z = 0.0;
 double base_z = 0.0;
-TBOOLEAN screen_ok;
 
 void map3d_xy (double x, double y, double z, unsigned int *xt, unsigned int *yt)
 {
--- Makefile.PL	2005-11-19 07:18:42.000000000 +0100
+++ Makefile.PL	2005-12-18 18:42:09.000000000 +0100
@@ -3,7 +3,7 @@
 # See lib/ExtUtils/MakeMaker.pm for details of how to influence
 # the contents of the Makefile that is written.
 
-$try_libs = ' -L/usr/openwin/lib -lX11 -lm  -lsocket -lvga -llinuxvga -lgd -lpng -lz -ljmgraph -lvesa';
+$try_libs = ' -L/usr/openwin/lib -L/usr/X11/lib -L/usr/X11R6/lib -lX11 -lm  -lsocket -lvga -llinuxvga -lgd -lpng -lz -ljmgraph -lvesa';
 
 @ARGV = grep !(/^TRY_LIBS=(.*)$/ and $try_libs = $1), @ARGV;
 
--- gnuterm/Makefile.PL	2005-05-14 02:15:56.000000000 +0200
+++ gnuterm/Makefile.PL	2005-12-18 15:20:24.000000000 +0100
@@ -35,6 +35,7 @@
 $cflags .= ' -DNOCOPY' unless $Config{d_bcopy};
 $cflags .= ' -Dsize_t=unsigned' unless $Config{sizetype} eq 'size_t';
 $cflags .= ' -Dtime_t=long' unless $Config{timetype} eq 'time_t';
+$cflags .= ' -DHAVE_SLEEP';
 
 # $cflags .= ' -DGETCWD -DHAVE_STRNICMP -DPIPES -DHAVE_STRERROR -DNOGAMMA' if $^O eq 'os2';
 if ($^O eq 'os2' or $^O eq 'MSWin32') {
--- gnuterm/term.h	1999-11-05 00:49:48.000000000 +0100
+++ gnuterm/term.h	2005-12-18 18:26:23.000000000 +0100
@@ -137,11 +137,6 @@
 # include "next.trm"
 #endif
 
-/* Apple MacOs X Server (Openstep Unix) */
-#if defined(__APPLE__) && defined(__MACH__)
-# include "openstep.trm"
-#endif 
-
 /* OS/2 */
 #ifdef OS2
 /* presentation manager */
