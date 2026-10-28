--- test/tc_password.rb.orig	Wed Apr 21 12:46:31 2004
+++ test/tc_password.rb	Wed Apr 21 12:52:11 2004
@@ -77,7 +77,11 @@
   def test_crypt
     pw = Password.random( LENGTH )
     assert_nothing_raised { pw.crypt( Password::DES ) }
+	if `uname`.chomp == "Linux"
     assert_nothing_raised { pw.crypt( Password::MD5 ) }
+	else
+		assert_raises( Password::CryptError ) { pw.crypt( Password::MD5 ) }
+	end
     assert_raises( Password::CryptError ) { pw.crypt( Password::DES, '@*' ) }
   end
 
