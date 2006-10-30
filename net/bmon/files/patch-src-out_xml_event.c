diff -ru ../bmon-2.1.0.orig/src/out_xml_event.c ./src/out_xml_event.c
--- ../bmon-2.1.0.orig/src/out_xml_event.c	2005-04-05 08:01:33.000000000 -0700
+++ ./src/out_xml_event.c	2006-10-26 17:23:44.548993579 -0700
@@ -127,7 +127,7 @@
 	.om_draw = xml_event_draw,
 	.om_set_opts = xml_event_set_opts,
 	.om_probe = xml_event_probe,
-	.om_shutdown xml_event_shutdown,
+	.om_shutdown = xml_event_shutdown,
 };
 
 static void __init xml_event_init(void)
