--- components/image_properties/nautilus-image-properties-view.c.orig	Tue Mar  9 06:23:37 2004
+++ components/image_properties/nautilus-image-properties-view.c	Wed Oct 13 01:38:33 2004
@@ -124,13 +124,14 @@
 exif_content_callback (ExifContent *content, gpointer data)
 {
 	struct ExifAttribute *attribute;
+        char value[1024];
 
 	attribute = (struct ExifAttribute *)data;
 	if (attribute->found) {
 		return;
 	}
 
-        attribute->value = g_strdup (exif_content_get_value (content, attribute->tag));
+        attribute->value = g_strdup (exif_content_get_value (content, attribute->tag, value, sizeof(value)));
 	if (attribute->value != NULL) {
 		attribute->found = TRUE;
 	}
