--- ZPhotoSlides/__init__.py.orig	Mon Mar 15 08:47:41 2004
+++ ZPhotoSlides/__init__.py	Mon Mar 15 08:48:10 2004
@@ -67,7 +67,7 @@
             contentConstructors = (ZPhotoSlides.manage_addZPhotoSlides, ZPhotoSlidesFolder.manage_addZPhotoSlidesFolder, ) 
             install_globals = globals() # Used only in the Extensions/Install.py scrip
             utils.ContentInit(
-                 'ZPhotoSlides',
+                 'CMF ZPhotoSlides',
                  content_types = contentClasses, 
                  permission = "Add ZPhotoSlides",
                  extra_constructors = contentConstructors,
