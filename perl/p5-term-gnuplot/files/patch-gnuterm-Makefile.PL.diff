--- Gnuplot.h	2006-05-26 10:21:38.000000000 +0200
+++ Gnuplot.h	2006-10-04 23:47:31.000000000 +0200
@@ -210,7 +210,6 @@
 double log_base_log_y = 0.0;
 double log_base_log_z = 0.0;
 double base_z = 0.0;
-TBOOLEAN screen_ok;
 
 void map3d_xy (double x, double y, double z, unsigned int *xt, unsigned int *yt)
 {
@@ -490,7 +489,7 @@
 extern struct termentry *term;
 
 #ifndef GNUPLOT_NO_CODE_EMIT
-struct termentry *term;
+struct termentry *term = NULL;
 #endif /* !GNUPLOT_NO_CODE_EMIT */
 
 #define RETVOID
--- Makefile.PL	2006-05-26 08:29:40.000000000 +0200
+++ Makefile.PL	2006-10-04 21:56:31.000000000 +0200
@@ -8,7 +8,7 @@
   if exists $ENV{X11ROOT} and -d "$ENV{X11ROOT}/XFree86/lib" and -d "$ENV{X11ROOT}/XFree86/include";
 
 $try_libs = $common::x ? "-L$common::x/lib" : '';
-$try_libs .= ' -L/usr/openwin/lib -lX11 -lm -lsocket -lvga -llinuxvga -lgd -lpng -ljpeg -lfreetype -lz -ljmgraph -lvesa -lpdf';
+$try_libs .= ' -L/usr/openwin/lib -L/usr/X11/lib -L/usr/X11R6/lib -lX11 -lm -lsocket -lvga -llinuxvga -lgd -lpng -ljpeg -lfreetype -lz -ljmgraph -lvesa -lpdf';
 
 @ARGV = grep !(/^TRY_LIBS=(.*)$/ and $try_libs = $1), @ARGV;
 
--- gnuterm/Makefile.PL	2006-05-25 01:01:04.000000000 +0200
+++ gnuterm/Makefile.PL	2006-10-04 22:18:10.000000000 +0200
@@ -12,6 +12,7 @@
 $cflags .= ' -DMY_Windows' if $^O eq 'MSWin32';
 
 $cflags .= $common::cflags;
+$cflags .= ' -DHAVE_SLEEP';
 
 $try_libs = $common::try_libs;
 
--- gnuterm/term.c	2002-09-07 01:18:30.000000000 +0200
+++ gnuterm/term.c	2006-10-05 00:20:35.000000000 +0200
@@ -111,14 +111,14 @@
 
 /* Externally visible variables */
 /* the central instance: the current terminal's interface structure */
-struct termentry *term = NULL;	/* unknown */
+/* struct termentry *term = NULL; (defined in Gnuplot.h) */
 
 /* ... and its options string */
 char term_options[MAX_LINE_LEN+1] = "";
 
 /* the 'output' file name and handle */
 char *outstr = NULL;		/* means "STDOUT" */
-FILE *gpoutfile;
+/* FILE *gpoutfile; (defined in Gnuplot.h) */
 
 #ifdef PM3D
 /* Output file where the PostScript output goes to. See term_api.h for more
@@ -137,7 +137,7 @@
 TBOOLEAN ignore_enhanced_text = FALSE;
 
 /* text output encoding, for terminals that support it */
-enum set_encoding_id encoding;
+/* enum set_encoding_id encoding; (defined in Gnuplot.h) */
 /* table of encoding names, for output of the setting */
 const char *encoding_names[] = {
     "default", "iso_8859_1", "iso_8859_2", "cp437", "cp850", "cp852", NULL };
@@ -179,6 +179,8 @@
 /* internal pointsize for do_point */
 static double term_pointsize=1;
 
+label_struct title;
+
 /* Internal prototypes: */
 
 static void term_suspend __PROTO((void));
--- gnuterm/term.h	1999-11-05 00:49:48.000000000 +0100
+++ gnuterm/term.h	2005-12-18 18:26:23.000000000 +0100
@@ -144,11 +144,6 @@
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
