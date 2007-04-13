--- lib/gnutlsxx.cpp	2006-06-02 05:49:01.000000000 +1000
+++ lib/gnutlsxx.cpp	2007-01-25 20:40:26.000000000 +1100
@@ -822,11 +822,16 @@
 { 
 }
 
+#if !(defined(__APPLE__) || defined(__MACOS__))
+/* FIXME: This #if is due to a compile bug in Mac OS X.  Give it some
+   time and then remove this cruft.  See also
+   includes/gnutls/gnutlsxx.h. */
 credentials::credentials( credentials& c)
 {
     this->type = c.type;
     this->set_ptr( c.ptr());
 }
+#endif
 
 gnutls_credentials_type_t credentials::get_type() const
 { 
