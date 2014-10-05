From 45deae03e8d0d53de82de14fbe189930d7133592 Mon Sep 17 00:00:00 2001
From: Jasper Lievisse Adriaanse <jasper@humppa.nl>
Date: Mon, 15 Sep 2014 09:01:47 +0200
Subject: Prevent redefinition of VteCharAttributes as that breaks GCC 4.2


diff --git a/src/vteterminal.h b/src/vteterminal.h
index d5dc089..88e21b8 100644
--- src/vteterminal.h
+++ src/vteterminal.h
@@ -111,7 +111,6 @@ struct _VteTerminalClass {
 };
 
 /* The structure we return as the supplemental attributes for strings. */
-typedef struct _VteCharAttributes VteCharAttributes;
 struct _VteCharAttributes {
         /*< private >*/
 	long row, column;
-- 
cgit v0.10.1

