--- libsmb/clikrb5.c	Sun Nov  7 21:43:23 2004
+++ libsmb/clikrb5.c.new	Wed Jan  5 00:38:45 2005
@@ -53,8 +53,13 @@
 }
 #endif
 
-#if defined(HAVE_KRB5_SET_DEFAULT_IN_TKT_ETYPES) && !defined(HAVE_KRB5_SET_DEFAULT_TGS_KTYPES)
- krb5_error_code krb5_set_default_tgs_ktypes(krb5_context ctx, const krb5_enctype *enc)
+#if defined(__APPLE__) && !defined(HAVE_KRB5_SET_DEFAULT_TGS_KTYPES)
+krb5_error_code krb5_set_default_tgs_ktypes(krb5_context ctx, const krb5_enctype *enc)
+{
+	return krb5_set_default_tgs_enctypes(ctx, enc);
+}
+#elif defined(HAVE_KRB5_SET_DEFAULT_IN_TKT_ETYPES) && !defined(HAVE_KRB5_SET_DEFAULT_TGS_KTYPES)
+	 krb5_error_code krb5_set_default_tgs_ktypes(krb5_context ctx, const krb5_enctype *enc)
 {
 	return krb5_set_default_in_tkt_etypes(ctx, enc);
 }
@@ -206,6 +211,7 @@
 #if !defined(HAVE_KRB5_LOCATE_KDC)
  krb5_error_code krb5_locate_kdc(krb5_context ctx, const krb5_data *realm, struct sockaddr **addr_pp, int *naddrs, int get_masters)
 {
+#ifndef __APPLE__
 	krb5_krbhst_handle hnd;
 	krb5_krbhst_info *hinfo;
 	krb5_error_code rc;
@@ -261,6 +267,10 @@
 
 	*naddrs = num_kdcs;
 	*addr_pp = sa;
+#else
+	DEBUG(0, ("krb5_locate_kdc: this function is not implemented on this platform\n"));
+	return -1;
+#endif
 	return 0;
 }
 #endif
