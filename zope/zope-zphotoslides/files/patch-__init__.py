--- __init__.py.orig	Tue Dec 16 13:50:14 2003
+++ __init__.py	Tue Dec 16 13:50:21 2003
@@ -68,7 +68,7 @@
             contentConstructors = (ZPhotoSlides.manage_addZPhotoSlides, ZPhotoSlidesFolder.manage_addZPhotoSlidesFolder, ) 
             install_globals = globals() # Used only in the Extensions/Install.py scrip
             utils.ContentInit(
-                 'ZPhotoSlides',
+                 'CMF ZPhotoSlides',
                  content_types = contentClasses, 
                  permission = "Add ZPhotoSlides",
                  extra_constructors = contentConstructors,
