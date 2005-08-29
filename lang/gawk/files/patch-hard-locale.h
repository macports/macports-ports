--- hard-locale.h.orig	2005-08-29 14:16:31.000000000 -0700
+++ hard-locale.h	2005-08-29 14:16:53.000000000 -0700
@@ -22,6 +22,8 @@
    Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */
 
 
+static ptr_t xmalloc PARAMS ((size_t n));
+
 /* Return nonzero if the current CATEGORY locale is hard, i.e. if you
    can't get away with assuming traditional C or POSIX behavior.  */
 static int
@@ -40,8 +42,6 @@
       if (strcmp (p, "C") == 0 || strcmp (p, "POSIX") == 0)
 	hard = 0;
 # else
-      static ptr_t xmalloc PARAMS ((size_t n));
-
       char *locale = xmalloc (strlen (p) + 1);
       strcpy (locale, p);
 
