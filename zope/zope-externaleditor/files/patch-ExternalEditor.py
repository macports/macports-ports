--- ExternalEditor.py.orig	Tue Mar  4 11:24:42 2003
+++ ExternalEditor.py	Mon Jan 12 20:52:17 2004
@@ -48,6 +48,9 @@
             path[:] = []
         else:
             request.set('target', None)
+        sniffer = self.UserSniffer()
+        platform = sniffer['platform']
+        request.set('platform', platform)
     
     def index_html(self, REQUEST, RESPONSE, path=None):
         """Publish the object to the external editor helper app"""
@@ -135,6 +138,8 @@
             raise 'BadRequest', 'Object does not support external editing'
         
         RESPONSE.setHeader('Content-Type', 'application/x-zope-edit')    
+        if 'Mac' == REQUEST['platform']:
+            RESPONSE.setHeader('Content-Disposition', 'attachment; filename=%s.zem' % REQUEST['target'])
         return join(r, '\n')
 
 InitializeClass(ExternalEditor)
