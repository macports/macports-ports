--- ice-9/slib.scm	2006-02-18 07:08:44.000000000 +0100
+++ ice-9/slib.scm	2007-03-28 01:11:35.000000000 +0200
@@ -16,6 +16,13 @@
 ;;;; License along with this library; if not, write to the Free Software
 ;;;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 ;;;;
+
+;; forward patch GDT's 1.6.7 pkgsrc patch
+;; ref. http://lists.gnu.org/archive/html/guile-user/2005-10/msg00083.html
+;; Load slib's init routine.
+(load (string-append (assoc-ref %guile-build-info 'pkgdatadir)
+		"/slib/guile.init"))
+
 (define-module (ice-9 slib)
   :export (slib:load slib:load-source defmacro:load
 	   implementation-vicinity library-vicinity home-vicinity
