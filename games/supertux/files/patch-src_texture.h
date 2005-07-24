--- src/texture.h.orig	2005-07-23 18:12:18.000000000 -0700
+++ src/texture.h	2005-07-23 18:12:44.000000000 -0700
@@ -137,7 +137,7 @@ public:
 class SurfaceOpenGL : public SurfaceImpl
 {
 public:
-  unsigned gl_texture;
+  GLuint gl_texture;
 
 public:
   SurfaceOpenGL(SDL_Surface* surf, int use_alpha);
