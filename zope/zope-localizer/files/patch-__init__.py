--- Localizer/__init__.py.orig	Mon Mar 15 10:00:01 2004
+++ Localizer/__init__.py	Mon Mar 15 10:00:42 2004
@@ -158,9 +158,9 @@
 
     from Products.PageTemplates.TALES import Context, Default
 
-    def evaluateText(self, expr, None=None):
+    def evaluateText(self, expr, none=None):
         text = self.evaluate(expr)
-        if text is Default or text is None:
+        if text is Default or text is none:
             return text
         return ustr(text) # Use "ustr" instead of "str"
     Context.evaluateText = evaluateText
