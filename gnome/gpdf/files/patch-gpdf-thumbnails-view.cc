--- xpdf/gpdf-thumbnails-view.cc.org	2005-03-25 17:48:14.000000000 +0100
+++ xpdf/gpdf-thumbnails-view.cc	2005-03-25 17:49:50.000000000 +0100
@@ -344,7 +344,7 @@
 
 	if (y) {
 		*y = GPDF_THUMBNAILS_MARGIN_TOP +
-			(uint)((page -1) / priv->page_per_row) *
+			(guint)((page -1) / priv->page_per_row) *
 			(priv->max_page_height + GPDF_THUMBNAILS_ROW_SEP +
 			 GPDF_THUMBNAILS_TEXT_HEIGHT +
 			 GPDF_THUMBNAILS_INNER_MARGIN_BOTTOM +
