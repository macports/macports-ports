--- v3p/mpeg2/libmpeg2/idct_altivec.c.orig	2008-12-02 20:17:34.000000000 -0800
+++ v3p/mpeg2/libmpeg2/idct_altivec.c	2008-12-02 20:17:45.000000000 -0800
@@ -21,7 +21,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifndef __ALTIVEC__
+#if 1
 
 #include "config.h"
 
