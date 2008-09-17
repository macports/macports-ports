--- gcc/f/com.h	2006-11-05 08:54:21.000000000 +0900
+++ gcc/f/com.h	2006-11-05 08:54:00.000000000 +0900
@@ -233,7 +233,7 @@
 void ffecom_finish_progunit (void);
 tree ffecom_get_invented_identifier (const char *pattern, ...)
   ATTRIBUTE_PRINTF_1;
-ffeinfoKindtype ffecom_gfrt_basictype (ffecomGfrt ix);
+ffeinfoBasictype ffecom_gfrt_basictype (ffecomGfrt ix);
 ffeinfoKindtype ffecom_gfrt_kindtype (ffecomGfrt ix);
 void ffecom_init_0 (void);
 void ffecom_init_2 (void);
