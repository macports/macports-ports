--- setup.py	Mon Jan 31 15:42:19 2005
+++ setup.py.new	Tue Apr 19 10:45:01 2005
@@ -77,10 +77,7 @@
           '   2. GnuTLS\n' \
           '   3. NSS\n' \
           'Your choice : '
-    reply = raw_input(msg)
-    choice = None
-    if reply:
-        choice = reply[0]
+    choice = 1
     if choice == '1':
         xmlsec1_crypto = "openssl"
     elif choice == '2':
