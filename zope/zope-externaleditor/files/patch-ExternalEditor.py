--- ExternalEditor.py.orig	Fri Mar  5 12:02:24 2004
+++ ExternalEditor.py	Fri Mar  5 12:01:54 2004
@@ -17,6 +17,7 @@
 # Zope External Editor Product by Casey Duncan
 
 from string import join # For Zope 2.3 compatibility
+import re
 import urllib
 import Acquisition
 from Globals import InitializeClass
@@ -32,6 +33,8 @@
 
 ExternalEditorPermission = 'Use external editor'
 
+mac_user_agent_pattern = re.compile( '.*Mac OS X.*|.*Mac_PowerPC.*' )
+
 class ExternalEditor(Acquisition.Implicit):
     """Create a response that encapsulates the data needed by the
        ZopeEdit helper application
@@ -44,6 +47,8 @@
         path = request['TraversalRequestNameStack']
         if path:
             target = path[-1]
+            if mac_user_agent_pattern.match( request['HTTP_USER_AGENT'] ):
+                target = target.replace( '.zem', '' )
             request.set('target', target)
             path[:] = []
         else:
@@ -148,8 +153,13 @@
                 or hasattr(base, 'document_src')
                 or hasattr(base, 'read'))
     if editable and user.has_permission(ExternalEditorPermission, object):
-        url = "%s/externalEdit_/%s" % (
-            object.aq_parent.absolute_url(), urllib.quote(object.getId()))
+        ext = ( mac_user_agent_pattern.match(
+            object.REQUEST['HTTP_USER_AGENT'] )
+                and '.zem'
+                or '' )
+        url = "%s/externalEdit_/%s%s" % ( object.aq_parent.absolute_url()
+                                        , urllib.quote(object.getId())
+                                        , ext )
         if borrow_lock:
             url += '?borrow_lock=1'
         return ('<a href="%s" '
