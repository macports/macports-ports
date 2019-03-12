--- python/omniidl_be/dir.mk.orig	2003-03-23 21:51:59.000000000 +0000
+++ python/omniidl_be/dir.mk	2017-11-10 11:15:00.000000000 +0000
@@ -6,7 +6,7 @@
 PYTHON = python
 endif
 
-FILES = __init__.py python.py
+FILES = python.py
 
 export:: $(FILES)
 	@(dir="$(PYLIBDIR)"; \
