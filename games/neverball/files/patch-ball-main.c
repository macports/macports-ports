--- ball/main.c.old	Sat Feb 12 23:07:56 2005
+++ ball/main.c	Sat Feb 12 23:08:18 2005
@@ -97,11 +97,7 @@
             {
             case SDL_MOUSEMOTION:
                 st_point(+e.motion.x,
-#ifdef __APPLE__
-                         +e.motion.y,
-#else
                          -e.motion.y + config_get_d(CONFIG_HEIGHT),
-#endif
                          +e.motion.xrel,
                          config_get_d(CONFIG_MOUSE_INVERT)
                          ? +e.motion.yrel : -e.motion.yrel);
