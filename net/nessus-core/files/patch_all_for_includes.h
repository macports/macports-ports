diff -ru Makefile Makefile
--- Makefile	Tue Jan 21 02:45:03 2003
+++ Makefile	Wed Sep 15 13:29:16 2004
@@ -39,7 +39,7 @@
 	test -d $(DESTDIR)${NESSUSD_LOGDIR} || $(INSTALL_DIR) -m 755 $(DESTDIR)${NESSUSD_LOGDIR}
 	$(INSTALL) -c -m 0444 include/config.h $(DESTDIR)${includedir}/nessus
 	$(INSTALL) -c -m 0444 include/ntcompat.h $(DESTDIR)${includedir}/nessus
-	$(INSTALL) -c -m 0444 include/includes.h $(DESTDIR)${includedir}/nessus
+	$(INSTALL) -c -m 0444 include/nessus-core-includes.h $(DESTDIR)${includedir}/nessus
 	$(INSTALL) -c -m 0444 include/nessus-devel.h $(DESTDIR)${includedir}/nessus
 	$(INSTALL) -c -m 0444 include/nessusraw.h $(DESTDIR)${includedir}/nessus
 	$(INSTALL) -c -m 0444 include/nessusip.h $(DESTDIR)${includedir}/nessus
diff -ru nessus/attack.c nessus/attack.c
--- nessus/attack.c	Mon Aug 26 11:58:03 2002
+++ nessus/attack.c	Wed Sep 15 13:29:20 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "comm.h"
 #include "auth.h"
 #include "parser.h"
diff -ru nessus/auth.c nessus/auth.c
--- nessus/auth.c	Tue Jun  3 06:14:54 2003
+++ nessus/auth.c	Wed Sep 15 13:29:31 2004
@@ -30,7 +30,7 @@
  */
 
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <stdarg.h>
 #include "comm.h"
 #include "auth.h"
diff -ru nessus/backend.c nessus/backend.c
--- nessus/backend.c	Mon Jun 14 13:50:41 2004
+++ nessus/backend.c	Wed Sep 15 13:29:36 2004
@@ -36,7 +36,7 @@
  * a MySQL module.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "backend.h"
 #include "nsr_output.h"
 #include "nbe_output.h"
diff -ru nessus/cli.c nessus/cli.c
--- nessus/cli.c	Wed Oct  1 11:29:11 2003
+++ nessus/cli.c	Wed Sep 15 13:29:39 2004
@@ -33,7 +33,7 @@
  *
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "globals.h"
 
 #include "nessus.h"
diff -ru nessus/comm.c nessus/comm.c
--- nessus/comm.c	Fri Jan 16 13:55:10 2004
+++ nessus/comm.c	Wed Sep 15 13:29:41 2004
@@ -30,7 +30,7 @@
  *
  */ 
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #include "auth.h"
 #include "comm.h" 
diff -ru nessus/data_mining.c nessus/data_mining.c
--- nessus/data_mining.c	Fri Jan 16 13:55:10 2004
+++ nessus/data_mining.c	Wed Sep 15 13:29:44 2004
@@ -39,7 +39,7 @@
  */
  
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <stdarg.h>
 #include "backend.h"
 #include "data_mining.h"
diff -ru nessus/detached_index.c nessus/detached_index.c
--- nessus/detached_index.c	Sun Apr 11 05:29:42 2004
+++ nessus/detached_index.c	Wed Sep 15 13:29:47 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK
 #include "gtk-compat.h"
diff -ru nessus/error_dialog.c nessus/error_dialog.c
--- nessus/error_dialog.c	Sun Apr 11 05:29:43 2004
+++ nessus/error_dialog.c	Wed Sep 15 13:29:49 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "globals.h"
 #ifndef USE_GTK 
 
diff -ru nessus/families.c nessus/families.c
--- nessus/families.c	Thu Jan 23 10:05:53 2003
+++ nessus/families.c	Wed Sep 15 13:29:50 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #ifdef USE_GTK
 #include <gtk/gtk.h>
 #endif
diff -ru nessus/filter.c nessus/filter.c
--- nessus/filter.c	Fri Apr  9 14:21:02 2004
+++ nessus/filter.c	Wed Sep 15 13:29:51 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #ifdef USE_GTK
 #ifdef HAVE_REGEX_SUPPORT
 #include <regex.h>
diff -ru nessus/gdchart0.94b/gdc.c nessus/gdchart0.94b/gdc.c
--- nessus/gdchart0.94b/gdc.c	Wed May 21 09:05:37 2003
+++ nessus/gdchart0.94b/gdc.c	Wed Sep 15 13:29:55 2004
@@ -2,7 +2,7 @@
 
 #define GDC_INCL
 #define GDC_LIB
-#include "includes.h"
+#include "nessus-core-includes.h"
 #include "gdc.h"
 
 struct	GDC_FONT_T	GDC_fontc[GDC_numfonts] = { 					   {(gdFontPtr)NULL, 8,  5},
diff -ru nessus/gdchart0.94b/gdc.h nessus/gdchart0.94b/gdc.h
--- nessus/gdchart0.94b/gdc.h	Wed May 21 09:05:37 2003
+++ nessus/gdchart0.94b/gdc.h	Wed Sep 15 13:29:57 2004
@@ -7,7 +7,7 @@
 #ifndef _GDC_H
 #define _GDC_H
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <math.h>
 #ifdef GDC_INCL
 #include "gd.h"
diff -ru nessus/gdchart0.94b/gdc_pie.c nessus/gdchart0.94b/gdc_pie.c
--- nessus/gdchart0.94b/gdc_pie.c	Wed May 21 09:05:37 2003
+++ nessus/gdchart0.94b/gdc_pie.c	Wed Sep 15 13:29:59 2004
@@ -1,6 +1,6 @@
 /* GDCHART 0.94b  GDC_PIE.C  12 Nov 1998 */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef HAVE_FLOAT_H
 #include <float.h>
diff -ru nessus/gdchart0.94b/gdc_pie_samp.c nessus/gdchart0.94b/gdc_pie_samp.c
--- nessus/gdchart0.94b/gdc_pie_samp.c	Fri Mar 17 05:23:13 2000
+++ nessus/gdchart0.94b/gdc_pie_samp.c	Wed Sep 15 13:30:00 2004
@@ -3,7 +3,7 @@
 /* creates a file "pie.gif".  Can be stdout for CGI use. */
 /*  vi: :set tabstop=4 */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "math.h"
 #include "gdc.h"
 #include "gdcpie.h"
diff -ru nessus/gdchart0.94b/gdchart.c nessus/gdchart0.94b/gdchart.c
--- nessus/gdchart0.94b/gdchart.c	Wed May 21 09:30:47 2003
+++ nessus/gdchart0.94b/gdchart.c	Wed Sep 15 13:30:01 2004
@@ -1,7 +1,7 @@
 /* GDCHART 0.94b  GDCHART.C  18 APR 1999 */
 /* vi:set tabstop=4 */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <limits.h>
 
 #include <math.h>
diff -ru nessus/html_graph_output.c nessus/html_graph_output.c
--- nessus/html_graph_output.c	Mon Jul 19 12:49:44 2004
+++ nessus/html_graph_output.c	Wed Sep 15 13:30:04 2004
@@ -64,7 +64,7 @@
 	- HTML report
 
  -------------------------------------------------------------------*/	
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "gdchart0.94b/gdc.h"
 #include "gdchart0.94b/gdchart.h"
 #include "gdchart0.94b/gdcpie.h"
diff -ru nessus/html_output.c nessus/html_output.c
--- nessus/html_output.c	Wed Jul 30 08:00:14 2003
+++ nessus/html_output.c	Wed Sep 15 13:30:07 2004
@@ -37,7 +37,7 @@
  *
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "report.h"
 #include "report_utils.h"
 #include "error_dialog.h"
diff -ru nessus/latex_output.c nessus/latex_output.c
--- nessus/latex_output.c	Fri Feb 14 01:42:47 2003
+++ nessus/latex_output.c	Wed Sep 15 13:30:08 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "report.h"
 #include "report_utils.h"
 #include "globals.h"
diff -ru nessus/monitor_backend.c nessus/monitor_backend.c
--- nessus/monitor_backend.c	Mon Aug 26 11:58:04 2002
+++ nessus/monitor_backend.c	Wed Sep 15 13:30:10 2004
@@ -35,7 +35,7 @@
  * reads it at the end of the scan.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "monitor_backend.h"
 #include "nsr_output.h"
 #include "error_dialog.h"
diff -ru nessus/monitor_dialog.c nessus/monitor_dialog.c
--- nessus/monitor_dialog.c	Wed Jan 14 08:06:16 2004
+++ nessus/monitor_dialog.c	Wed Sep 15 13:30:13 2004
@@ -27,7 +27,7 @@
  *
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #include "backend.h"
 #if USE_GTK 
diff -ru nessus/nbe_output.c nessus/nbe_output.c
--- nessus/nbe_output.c	Fri Jan 16 13:55:10 2004
+++ nessus/nbe_output.c	Wed Sep 15 13:30:15 2004
@@ -27,7 +27,7 @@
  * do so, delete this exception statement from your version.
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "report.h"
 #include "error_dialog.h"
 #include "backend.h"
diff -ru nessus/nessus.c nessus/nessus.c
--- nessus/nessus.c	Tue Feb 17 08:09:17 2004
+++ nessus/nessus.c	Wed Sep 15 13:30:16 2004
@@ -27,7 +27,7 @@
  *
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "password_dialog.h"
 
 #ifdef USE_GTK
diff -ru nessus/netmap.c nessus/netmap.c
--- nessus/netmap.c	Mon Aug 26 11:58:05 2002
+++ nessus/netmap.c	Wed Sep 15 13:30:23 2004
@@ -35,7 +35,7 @@
  *
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK
 #include <gtk/gtk.h>
diff -ru nessus/nsr_output.c nessus/nsr_output.c
--- nessus/nsr_output.c	Tue Jul 29 07:47:51 2003
+++ nessus/nsr_output.c	Wed Sep 15 13:30:25 2004
@@ -27,7 +27,7 @@
  * do so, delete this exception statement from your version.
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "report.h"
 #include "error_dialog.h"
 #include "backend.h"
diff -ru nessus/parser.c nessus/parser.c
--- nessus/parser.c	Tue Sep 30 18:51:56 2003
+++ nessus/parser.c	Wed Sep 15 13:30:27 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "parser.h"
 #include "auth.h"
 #include "error_dialog.h"
diff -ru nessus/password_dialog.c nessus/password_dialog.c
--- nessus/password_dialog.c	Fri Apr  9 14:21:02 2004
+++ nessus/password_dialog.c	Wed Sep 15 13:30:29 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef HAVE_SIGNAL_H
 # include <signal.h>
diff -ru nessus/plugin_infos.c nessus/plugin_infos.c
--- nessus/plugin_infos.c	Sun Apr 11 05:29:43 2004
+++ nessus/plugin_infos.c	Wed Sep 15 13:30:30 2004
@@ -28,7 +28,7 @@
  */
  
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK 
 #include "gtk-compat.h"
diff -ru nessus/preferences.c nessus/preferences.c
--- nessus/preferences.c	Mon Dec 15 08:03:38 2003
+++ nessus/preferences.c	Wed Sep 15 13:30:32 2004
@@ -29,7 +29,7 @@
  *
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "preferences.h"
 #include "globals.h"
 #include "nessus.h"
diff -ru nessus/prefs_dialog/prefs_about.c nessus/prefs_dialog/prefs_about.c
--- nessus/prefs_dialog/prefs_about.c	Tue Jan 21 15:26:49 2003
+++ nessus/prefs_dialog/prefs_about.c	Wed Sep 15 13:30:33 2004
@@ -27,7 +27,7 @@
  * do so, delete this exception statement from your version.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK
 #include <gtk/gtk.h>
diff -ru nessus/prefs_dialog/prefs_dialog.c nessus/prefs_dialog/prefs_dialog.c
--- nessus/prefs_dialog/prefs_dialog.c	Tue Sep 30 18:50:12 2003
+++ nessus/prefs_dialog/prefs_dialog.c	Wed Sep 15 13:30:35 2004
@@ -27,7 +27,7 @@
  * do so, delete this exception statement from your version.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK
 #include <gtk/gtk.h>
diff -ru nessus/prefs_dialog/prefs_dialog_auth.c nessus/prefs_dialog/prefs_dialog_auth.c
--- nessus/prefs_dialog/prefs_dialog_auth.c	Fri Apr  9 14:21:03 2004
+++ nessus/prefs_dialog/prefs_dialog_auth.c	Wed Sep 15 13:30:37 2004
@@ -29,7 +29,7 @@
  */
  
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK
 #include <gtk/gtk.h>
diff -ru nessus/prefs_dialog/prefs_dialog_misc.c nessus/prefs_dialog/prefs_dialog_misc.c
--- nessus/prefs_dialog/prefs_dialog_misc.c	Mon Aug 26 11:58:07 2002
+++ nessus/prefs_dialog/prefs_dialog_misc.c	Wed Sep 15 13:30:38 2004
@@ -27,7 +27,7 @@
  * do so, delete this exception statement from your version.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK
 #include <gtk/gtk.h>
diff -ru nessus/prefs_dialog/prefs_dialog_plugins_prefs.c nessus/prefs_dialog/prefs_dialog_plugins_prefs.c
--- nessus/prefs_dialog/prefs_dialog_plugins_prefs.c	Fri Apr  9 14:15:34 2004
+++ nessus/prefs_dialog/prefs_dialog_plugins_prefs.c	Wed Sep 15 13:30:39 2004
@@ -27,7 +27,7 @@
  * do so, delete this exception statement from your version.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK
 #include <gtk/gtk.h>
diff -ru nessus/prefs_dialog/prefs_dialog_scan_opt.c nessus/prefs_dialog/prefs_dialog_scan_opt.c
--- nessus/prefs_dialog/prefs_dialog_scan_opt.c	Fri Apr  9 09:31:29 2004
+++ nessus/prefs_dialog/prefs_dialog_scan_opt.c	Wed Sep 15 13:30:40 2004
@@ -27,7 +27,7 @@
  * do so, delete this exception statement from your version.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK
 #include <gtk/gtk.h>
diff -ru nessus/prefs_dialog/prefs_dialog_user.c nessus/prefs_dialog/prefs_dialog_user.c
--- nessus/prefs_dialog/prefs_dialog_user.c	Fri Apr  9 14:21:03 2004
+++ nessus/prefs_dialog/prefs_dialog_user.c	Wed Sep 15 13:30:42 2004
@@ -27,7 +27,7 @@
  * do so, delete this exception statement from your version.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK
 #include <gtk/gtk.h>
diff -ru nessus/prefs_dialog/prefs_kb.c nessus/prefs_dialog/prefs_kb.c
--- nessus/prefs_dialog/prefs_kb.c	Mon Aug 26 11:58:07 2002
+++ nessus/prefs_dialog/prefs_kb.c	Wed Sep 15 13:30:43 2004
@@ -27,7 +27,7 @@
  * do so, delete this exception statement from your version.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef ENABLE_SAVE_KB
 #ifdef USE_GTK
diff -ru nessus/prefs_dialog/prefs_plugins.c nessus/prefs_dialog/prefs_plugins.c
--- nessus/prefs_dialog/prefs_plugins.c	Fri Apr  9 09:31:29 2004
+++ nessus/prefs_dialog/prefs_plugins.c	Wed Sep 15 13:30:44 2004
@@ -27,7 +27,7 @@
  * do so, delete this exception statement from your version.
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK
 #include <gtk/gtk.h>
diff -ru nessus/prefs_dialog/prefs_target.c nessus/prefs_dialog/prefs_target.c
--- nessus/prefs_dialog/prefs_target.c	Fri Apr  9 14:21:03 2004
+++ nessus/prefs_dialog/prefs_target.c	Wed Sep 15 13:30:45 2004
@@ -27,7 +27,7 @@
  * do so, delete this exception statement from your version.
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK
 #include <gtk/gtk.h>
diff -ru nessus/read_target_file.c nessus/read_target_file.c
--- nessus/read_target_file.c	Fri Jan 16 13:55:11 2004
+++ nessus/read_target_file.c	Wed Sep 15 13:30:48 2004
@@ -1,4 +1,4 @@
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <errno.h>
 
 #ifdef USE_GTK 
diff -ru nessus/regex.c nessus/regex.c
--- nessus/regex.c	Wed May 21 09:05:36 2003
+++ nessus/regex.c	Wed Sep 15 13:30:50 2004
@@ -40,7 +40,7 @@
 /* We need this for `regex.h', and perhaps for the Emacs include files.  */
 
 #include <config.h>
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifndef HAVE_REGEX_SUPPORT
 
diff -ru nessus/report.c nessus/report.c
--- nessus/report.c	Fri Apr  9 14:21:02 2004
+++ nessus/report.c	Wed Sep 15 13:30:51 2004
@@ -31,7 +31,7 @@
  * changed infos_and_holes_to into findings_to 
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "globals.h"
 #ifdef USE_GTK
 
diff -ru nessus/report_ng.c nessus/report_ng.c
--- nessus/report_ng.c	Tue Oct 21 14:21:05 2003
+++ nessus/report_ng.c	Wed Sep 15 13:30:52 2004
@@ -40,7 +40,7 @@
   *
   */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #ifdef USE_GTK
 #include <gtk/gtk.h>
 #include "xstuff.h"
diff -ru nessus/report_save.c nessus/report_save.c
--- nessus/report_save.c	Sun Apr 11 05:29:43 2004
+++ nessus/report_save.c	Wed Sep 15 13:30:54 2004
@@ -29,7 +29,7 @@
  */  
  
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #ifdef USE_GTK
 #include <gtk/gtk.h>
 #include "gtk-compat.h"
diff -ru nessus/report_utils.c nessus/report_utils.c
--- nessus/report_utils.c	Mon Aug 26 11:58:06 2002
+++ nessus/report_utils.c	Wed Sep 15 13:30:55 2004
@@ -25,7 +25,7 @@
  * file, but you are not obligated to do so.  If you do not wish to
  * do so, delete this exception statement from your version.
  */
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "report_utils.h"
  
  
diff -ru nessus/sighand.c nessus/sighand.c
--- nessus/sighand.c	Wed Apr  2 04:59:50 2003
+++ nessus/sighand.c	Wed Sep 15 13:30:56 2004
@@ -28,7 +28,7 @@
  * Signals handler
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "nsr_output.h"
 #include "error_dialog.h"
 #include "globals.h"
diff -ru nessus/sslui.c nessus/sslui.c
--- nessus/sslui.c	Mon Feb 17 05:58:51 2003
+++ nessus/sslui.c	Wed Sep 15 13:30:58 2004
@@ -28,7 +28,7 @@
  * UI hooks for the SSL questions
  *
  */
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_AF_UNIX
 #undef NESSUS_ON_SSL
diff -ru nessus/text_output.c nessus/text_output.c
--- nessus/text_output.c	Mon Aug 26 11:58:06 2002
+++ nessus/text_output.c	Wed Sep 15 13:57:20 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "report.h"
 #include "report_utils.h"
 #include "error_dialog.h"
diff -ru nessus/xml_output.c nessus/xml_output.c
--- nessus/xml_output.c	Mon Aug 26 11:58:06 2002
+++ nessus/xml_output.c	Wed Sep 15 13:31:03 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "report.h"
 #include "report_utils.h"
 #include "error_dialog.h"
diff -ru nessus/xml_output_ng.c nessus/xml_output_ng.c
--- nessus/xml_output_ng.c	Thu Jun 19 06:36:33 2003
+++ nessus/xml_output_ng.c	Wed Sep 15 13:31:04 2004
@@ -40,7 +40,7 @@
  */
 
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <stdarg.h>
 
 #include "report.h"
diff -ru nessus/xstuff.c nessus/xstuff.c
--- nessus/xstuff.c	Tue Oct 21 14:21:06 2003
+++ nessus/xstuff.c	Wed Sep 15 13:31:06 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef USE_GTK 
 #include <gtk/gtk.h>
diff -ru nessusd/attack.c nessusd/attack.c
--- nessusd/attack.c	Sat Jul 10 22:18:36 2004
+++ nessusd/attack.c	Wed Sep 15 13:31:13 2004
@@ -30,7 +30,7 @@
  *
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "attack.h"
 #include "log.h"
 #include "hosts_gatherer.h"
diff -ru nessusd/auth.c nessusd/auth.c
--- nessusd/auth.c	Mon Dec 15 06:30:12 2003
+++ nessusd/auth.c	Wed Sep 15 13:31:15 2004
@@ -33,7 +33,7 @@
  */
 
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <stdarg.h>
 
 #include "rules.h"
diff -ru nessusd/comm.c nessusd/comm.c
--- nessusd/comm.c	Mon Dec 15 06:30:12 2003
+++ nessusd/comm.c	Wed Sep 15 13:31:16 2004
@@ -29,7 +29,7 @@
  *
  */ 
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <corevers.h>
 #include <stdarg.h>
 
diff -ru nessusd/detached.c nessusd/detached.c
--- nessusd/detached.c	Thu Jul 24 05:48:37 2003
+++ nessusd/detached.c	Wed Sep 15 13:31:17 2004
@@ -29,7 +29,7 @@
  */
  
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #ifdef ENABLE_SAVE_KB
 
 #include "detached.h"
diff -ru nessusd/dirutils.c nessusd/dirutils.c
--- nessusd/dirutils.c	Mon Aug 26 11:58:29 2002
+++ nessusd/dirutils.c	Wed Sep 15 13:31:18 2004
@@ -26,7 +26,7 @@
  * file, but you are not obligated to do so.  If you do not wish to
  * do so, delete this exception statement from your version.
  */
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef _UNUSED_
 static char * env = "NESSUS_HOME";
diff -ru nessusd/hosts.c nessusd/hosts.c
--- nessusd/hosts.c	Tue Jul  1 14:03:51 2003
+++ nessusd/hosts.c	Wed Sep 15 13:31:18 2004
@@ -28,7 +28,7 @@
  * $Id: patch_all_for_includes.h,v 1.1 2004/09/27 04:32:36 ricci Exp $
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "utils.h"
 #include "log.h"
 #include "preferences.h"
diff -ru nessusd/jobs.c nessusd/jobs.c
--- nessusd/jobs.c	Thu May 22 06:11:05 2003
+++ nessusd/jobs.c	Wed Sep 15 13:31:21 2004
@@ -46,7 +46,7 @@
  *
  *
  */
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 
 /*--------------------------------------------------------------------------*
diff -ru nessusd/locks.c nessusd/locks.c
--- nessusd/locks.c	Thu May 22 06:11:05 2003
+++ nessusd/locks.c	Wed Sep 15 13:31:22 2004
@@ -29,7 +29,7 @@
  * Trivial file locking primitives
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "utils.h"
 #include "log.h"
 static char * 
diff -ru nessusd/log.c nessusd/log.c
--- nessusd/log.c	Fri Feb 14 10:54:32 2003
+++ nessusd/log.c	Wed Sep 15 13:31:23 2004
@@ -31,7 +31,7 @@
  
 
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <stdarg.h>
 #ifndef _CYGWIN_
 #include <syslog.h>
diff -ru nessusd/md5.c nessusd/md5.c
--- nessusd/md5.c	Thu May 22 06:11:05 2003
+++ nessusd/md5.c	Wed Sep 15 13:31:24 2004
@@ -34,7 +34,7 @@
  *
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 
 #ifdef HAVE_SSL
diff -ru nessusd/nasl_plugins.c nessusd/nasl_plugins.c
--- nessusd/nasl_plugins.c	Mon Sep 15 12:50:32 2003
+++ nessusd/nasl_plugins.c	Wed Sep 15 13:31:26 2004
@@ -29,7 +29,7 @@
  *
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <nasl.h>
 #include "pluginload.h"
 #include "plugs_hash.h"
diff -ru nessusd/nes_plugins.c nessusd/nes_plugins.c
--- nessusd/nes_plugins.c	Mon Sep 15 12:50:32 2003
+++ nessusd/nes_plugins.c	Wed Sep 15 13:31:26 2004
@@ -29,7 +29,7 @@
  *
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "pluginload.h"
 #include "plugs_hash.h"
 #include "processes.h"
diff -ru nessusd/nessusd.c nessusd/nessusd.c
--- nessusd/nessusd.c	Fri Jul  4 13:55:55 2003
+++ nessusd/nessusd.c	Wed Sep 15 13:31:28 2004
@@ -28,7 +28,7 @@
  * $Id: patch_all_for_includes.h,v 1.1 2004/09/27 04:32:36 ricci Exp $
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <harglists.h>
 
 #ifdef USE_AF_UNIX
diff -ru nessusd/ntp_10.c nessusd/ntp_10.c
--- nessusd/ntp_10.c	Fri Jan 31 06:44:46 2003
+++ nessusd/ntp_10.c	Wed Sep 15 13:31:29 2004
@@ -29,7 +29,7 @@
  *
  */ 
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #include "ntp.h"
 #include "comm.h"
diff -ru nessusd/ntp_11.c nessusd/ntp_11.c
--- nessusd/ntp_11.c	Sat Jul  3 10:29:24 2004
+++ nessusd/ntp_11.c	Wed Sep 15 13:31:30 2004
@@ -30,7 +30,7 @@
  *
  */ 
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <corevers.h>
 #ifdef USE_AF_UNIX
 #undef NESSUS_ON_SSL
diff -ru nessusd/parser.c nessusd/parser.c
--- nessusd/parser.c	Mon Aug 26 11:58:30 2002
+++ nessusd/parser.c	Wed Sep 15 13:31:31 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 /* 
  * This function extracts the string after the 
diff -ru nessusd/perl_plugins.c nessusd/perl_plugins.c
--- nessusd/perl_plugins.c	Mon Aug 26 11:58:31 2002
+++ nessusd/perl_plugins.c	Wed Sep 15 13:31:33 2004
@@ -29,7 +29,7 @@
  *
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef PERL_PLUGINS
 
diff -ru nessusd/piic.c nessusd/piic.c
--- nessusd/piic.c	Tue Jul  1 07:49:22 2003
+++ nessusd/piic.c	Wed Sep 15 13:31:34 2004
@@ -32,7 +32,7 @@
  * and put it in an arglist
  */ 
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "log.h"
 #include "save_kb.h"
 #include "utils.h"
diff -ru nessusd/pluginlaunch.c nessusd/pluginlaunch.c
--- nessusd/pluginlaunch.c	Tue Mar  2 16:56:45 2004
+++ nessusd/pluginlaunch.c	Wed Sep 15 13:31:35 2004
@@ -31,7 +31,7 @@
  */
  
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "pluginload.h"
 #include "piic.h"
 #include "plugs_req.h"
diff -ru nessusd/pluginload.c nessusd/pluginload.c
--- nessusd/pluginload.c	Sun Feb 16 12:26:44 2003
+++ nessusd/pluginload.c	Wed Sep 15 13:31:36 2004
@@ -29,7 +29,7 @@
  *
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 #ifdef NESSUSNT
 #include "wstuff.h"
diff -ru nessusd/pluginscheduler.c nessusd/pluginscheduler.c
--- nessusd/pluginscheduler.c	Sun Feb 23 12:21:16 2003
+++ nessusd/pluginscheduler.c	Wed Sep 15 13:31:37 2004
@@ -30,7 +30,7 @@
  *
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #define IN_SCHEDULER_CODE 1
 #include "pluginscheduler.h"
 #include "pluginload.h"
diff -ru nessusd/pluginupload.c nessusd/pluginupload.c
--- nessusd/pluginupload.c	Thu Jun 26 16:29:38 2003
+++ nessusd/pluginupload.c	Wed Sep 15 13:31:38 2004
@@ -31,7 +31,7 @@
  *
  *
  */
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "preferences.h"
 #include "users.h"
 #include "log.h"
diff -ru nessusd/plugs_hash.c nessusd/plugs_hash.c
--- nessusd/plugs_hash.c	Fri Jan 16 13:45:06 2004
+++ nessusd/plugs_hash.c	Wed Sep 15 13:31:39 2004
@@ -31,7 +31,7 @@
  *
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "./md5.h"
 #include "users.h"
 #include "log.h"
diff -ru nessusd/plugs_req.c nessusd/plugs_req.c
--- nessusd/plugs_req.c	Sat Jul  3 10:04:46 2004
+++ nessusd/plugs_req.c	Wed Sep 15 13:31:40 2004
@@ -29,7 +29,7 @@
  *
  */ 
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "plugs_req.h"
 
 /**********************************************************
diff -ru nessusd/preferences.c nessusd/preferences.c
--- nessusd/preferences.c	Fri Sep 26 08:03:04 2003
+++ nessusd/preferences.c	Wed Sep 15 13:31:41 2004
@@ -29,7 +29,7 @@
  *
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #ifdef NESSUSNT
 #include "wstuff.h"
 #endif /* defined(NESSUSNT) */
diff -ru nessusd/processes.c nessusd/processes.c
--- nessusd/processes.c	Mon Jun 30 13:00:33 2003
+++ nessusd/processes.c	Wed Sep 15 13:31:42 2004
@@ -28,7 +28,7 @@
  *
  */ 
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include <setjmp.h>
 #include "processes.h"
 #include "sighand.h"
diff -ru nessusd/rules.c nessusd/rules.c
--- nessusd/rules.c	Fri Feb 14 10:54:32 2003
+++ nessusd/rules.c	Wed Sep 15 13:31:43 2004
@@ -26,7 +26,7 @@
  * do so, delete this exception statement from your version.
  */           
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #ifdef NESSUSNT
 #include "wstuff.h"
 #else
diff -ru nessusd/save_kb.c nessusd/save_kb.c
--- nessusd/save_kb.c	Mon Jan 19 13:45:40 2004
+++ nessusd/save_kb.c	Wed Sep 15 13:31:45 2004
@@ -31,7 +31,7 @@
  *
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "log.h"
 #include "comm.h"
 #include "users.h"
diff -ru nessusd/save_tests.c nessusd/save_tests.c
--- nessusd/save_tests.c	Fri Jan 16 13:48:01 2004
+++ nessusd/save_tests.c	Wed Sep 15 13:31:47 2004
@@ -32,7 +32,7 @@
  *
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 #include "log.h"
 #include "comm.h"
 #include "users.h"
diff -ru nessusd/sighand.c nessusd/sighand.c
--- nessusd/sighand.c	Thu May 27 21:57:18 2004
+++ nessusd/sighand.c	Wed Sep 15 13:31:49 2004
@@ -28,7 +28,7 @@
  * Signals handlers
  */
 
-#include <includes.h>
+#include <nessus-core-includes.h>
 
 
 #ifndef NESSUSNT
diff -ru nessusd/users.c nessusd/users.c
--- nessusd/users.c	Mon Dec 15 06:30:13 2003
+++ nessusd/users.c	Wed Sep 15 14:18:27 2004
@@ -30,7 +30,7 @@
  *
  */
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #ifdef NESSUSNT
 #include "wstuff.h"
 #endif
diff -ru nessusd/utils.c nessusd/utils.c
--- nessusd/utils.c	Thu Oct 30 14:03:12 2003
+++ nessusd/utils.c	Wed Sep 15 13:31:53 2004
@@ -29,7 +29,7 @@
 
 
  
-#include <includes.h>
+#include <nessus-core-includes.h>
 #ifdef NESSUSNT
 #include "wstuff.h"
 #endif
