--- dicom/test/test_UID.py.orig	2011-01-27 12:23:41.000000000 -0600
+++ dicom/test/test_UID.py	2011-01-27 12:24:16.000000000 -0600
@@ -32,6 +32,16 @@
         uid = UID('1.2.840.10008.1.2')
         self.assertEqual(uid, 'Implicit VR Little Endian', "UID equality failed on name")
         self.assertEqual(uid, '1.2.840.10008.1.2', "UID equality failed on number string")
+    def testCompareNumber(self):
+        """UID: comparing against a number give False............."""
+        # From issue 96
+        uid = UID('1.2.3')
+        self.assertNotEqual(uid, 3, "Comparison against a number returned True")
+    def testCompareNone(self):
+        """UID: comparing against None give False................."""
+        # From issue 96
+        uid = UID('1.2.3')
+        self.assertNotEqual(uid, None, "Comparison against a number returned True")
     def testTransferSyntaxes(self):
         pass
         
