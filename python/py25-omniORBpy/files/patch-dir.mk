--- omniidl_be/dir.mk.orig	2006-08-06 20:20:23.000000000 +0100
+++ omniidl_be/dir.mk	2006-08-06 20:20:38.000000000 +0100
@@ -6,7 +6,7 @@
 PYTHON = python
 endif
 
-FILES = __init__.py python.py
+FILES = python.py
 
 export:: $(FILES)
 	@(dir="$(PYLIBDIR)"; \
