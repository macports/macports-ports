--- dotneato/common/quartzgen.c.org	Tue Oct 19 02:41:00 2004
+++ dotneato/common/quartzgen.c	Sat Apr  2 00:58:53 2005
@@ -25,12 +25,13 @@
  *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
+#include "render.h"
+
+#ifdef QUARTZ_RENDER
 #include <ApplicationServices/ApplicationServices.h>
 #include <QuickTime/QuickTime.h>
 #include <Quicktime/QuicktimeComponents.k.h>
 
-#include "render.h"
-
 #define MAX_QD 32767
 
 #define PDF_MAGIC "%PDF-"
@@ -808,7 +809,7 @@
 static void
 setup_view_port(GVC_t* gvc, graph_t* g, box bb)
 {
-	dpi = gvc->dpi < 1.0 ? DEFAULT_DPI : gvc->dpi;
+	dpi = GD_drawing(g)->dpi < 1.0 ? DEFAULT_DPI : GD_drawing(g)->dpi;
 	dev_scale = dpi / POINTS_PER_INCH;
 	
 	view_port = gvc->size;
@@ -1211,19 +1212,19 @@
 
 
 char*
-gd_textsize(char* str, char* fontname, double fontsz, pointf* textsize)
+quartz_textsize(textline_t* textline, char* fontname, double fontsz, char** fontpath)
 {
-	text_value* text = fetch_text(str,fontname,fontsz);
+	text_value* text = fetch_text(textline->str,fontname,fontsz);
 	if (text) {
 		ATSUTextMeasurement before,after,ascent,descent;
 		check_status ("ATSUGetUnjustifiedBounds",
 			ATSUGetUnjustifiedBounds(text->layout,
 			kATSUFromTextBeginning,kATSUToTextEnd,&before,&after,&ascent,&descent));
 		
-		textsize->x = Fix2X(after-before);
-		textsize->y = Fix2X(ascent+descent);
+		textline->width = Fix2X(after-before);
 	} else
-		textsize->x = textsize->y = 0.0;
+		textline->width = 0.0;
+	textline->xshow = NULL;
 		
     return NULL;
 }
@@ -1374,4 +1375,4 @@
     NULL, /* usershapesize */
 };
 
-
+#endif /* QUARTZ_RENDER */
