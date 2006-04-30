--- Lib/plat-mac/applesingle.py	2004-07-18 02:14:45.000000000 -0400
+++ Lib/plat-mac/applesingle.py	2006-03-29 19:48:18.000000000 -0500
@@ -25,14 +25,14 @@
     pass
 
 # File header format: magic, version, unused, number of entries
-AS_HEADER_FORMAT="LL16sh"
+AS_HEADER_FORMAT=">LL16sh"
 AS_HEADER_LENGTH=26
 # The flag words for AppleSingle
 AS_MAGIC=0x00051600
 AS_VERSION=0x00020000
 
 # Entry header format: id, offset, length
-AS_ENTRY_FORMAT="lll"
+AS_ENTRY_FORMAT=">lll"
 AS_ENTRY_LENGTH=12
 
 # The id values
