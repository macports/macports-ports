--- includes/gnutls/gnutlsxx.h	2006-08-07 22:40:23.000000000 +1000
+++ includes/gnutls/gnutlsxx.h	2007-01-25 20:40:43.000000000 +1100
@@ -233,7 +233,17 @@
 {
     public:
         credentials(gnutls_credentials_type_t t);
-        credentials( credentials& c);
+#if defined(__APPLE__) || defined(__MACOS__)
+	/* FIXME: This #if is due to a compile bug in Mac OS X.  Give
+	   it some time and then remove this cruft.  See also
+	   lib/gnutlsxx.cpp. */
+	credentials( credentials& c) {
+	  type = c.type;
+	  set_ptr( c.ptr());
+	}
+#else
+	credentials( credentials& c);
+#endif
         virtual ~credentials() { }
         gnutls_credentials_type_t get_type() const;
     protected:
