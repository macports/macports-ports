--- putt/main.c.old	Sat Feb 12 23:07:56 2005
+++ putt/main.c	Sat Feb 12 23:08:05 2005
@@ -103,11 +103,7 @@
             {
             case SDL_MOUSEMOTION:
                 st_point(+e.motion.x,
-#ifdef __APPLE__
-                         +e.motion.y,
-#else
                          -e.motion.y + config_get_d(CONFIG_HEIGHT),
-#endif
                          +e.motion.xrel,
                          -e.motion.yrel);
                 break;
