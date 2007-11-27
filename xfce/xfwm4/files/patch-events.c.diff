--- src/events.c.orig	2007-01-13 22:48:07.000000000 +0100
+++ src/events.c	2007-09-22 13:10:49.000000000 +0200
@@ -857,15 +857,17 @@
         win = ev->subwindow;
         screen_info = c->screen_info;
 
-        if ((ev->button == Button1) && (state == AltMask) && (screen_info->params->easy_click))
+        /* On Darwin, the alt keys can be mapped over to "XK_Mode_switch" - which causes AltMask to be zero... */
+
+        if ((ev->button == Button1) && (state == AltMask && AltMask != 0) && (screen_info->params->easy_click))
         {
             button1Action (c, ev);
         }
-        else if ((ev->button == Button2) && (state == AltMask) && (screen_info->params->easy_click))
+        else if ((ev->button == Button2) && (state == AltMask && AltMask != 0) && (screen_info->params->easy_click))
         {
             clientLower (c);
         }
-        else if ((ev->button == Button3) && (state == AltMask) && (screen_info->params->easy_click))
+        else if ((ev->button == Button3) && (state == AltMask && AltMask != 0) && (screen_info->params->easy_click))
         {
             if ((ev->x < c->width / 2) && (ev->y < c->height / 2))
             {
