--- sources/main.h	Mon Aug 30 13:19:03 2004
+++ sources/main.h.new	Mon Aug 30 16:48:33 2004
@@ -15,7 +15,9 @@
 
 You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */
-
+#define CONCAT(x,y)    x "" y
+#define STRING(z)      #z
+#define FUNCTION(a,b)  CONCAT( STRING(a), STRING(b) )
 
 /* --- CPP parsing options --- */
 #define PRINTF_DEBUG            /* enable this to print some debugging messages */
@@ -37,18 +39,18 @@
 #define MIME_TYPE_DEFAULT   "application/octet-stream"
 
 /* configuration file location */
-#define DEFAULT_CONFIG_LOCATION "/usr/people/multix/pserv/defaults/"
+#define DEFAULT_CONFIG_LOCATION FUNCTION( PREFIX, /etc/pserv/ )
 
 /* hard-wired defaults, if loading of config file fails */
 #define DEFAULT_PORT	    	2000
 #define DEFAULT_MAX_CHILDREN	5
-#define DEFAULT_DOCS_LOCATION	"/home/multix/public_html"
+#define DEFAULT_DOCS_LOCATION	FUNCTION( PREFIX, /var/www )
 #define DEFAULT_FILE_NAME   	"index.html"
 #define DEFAULT_SEC_TO	    	1
 #define DEFAULT_USEC_TO     	100
-#define DEFAULT_LOG_FILE    	"/home/multix/pserv/pserv.log"
-#define DEFAULT_MIME_FILE   	"/home/multix/pserv/mime_types.dat"
-#define DEFAULT_CGI_ROOT    	"/home/multix/public_html/cgi-bin"
+#define DEFAULT_LOG_FILE    	FUNCTION( PREFIX, /var/log/pserv/pserv.log )
+#define DEFAULT_MIME_FILE   	FUNCTION( PREFIX, /share/pserv/mime_types.dat )
+#define DEFAULT_CGI_ROOT    	FUNCTION( PREFIX, /var/www/cgi-bin )
 #define DEFAULT_SERVER_NAME 	"localhost"
 
 /* amount of connections queued in listening */
