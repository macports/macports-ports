--- ext/openssl/ossl_engine.c	2004-12-15 02:54:39.000000000 +0100
+++ ext/openssl/ossl_engine.c	2005-07-23 16:09:01.000000000 +0200
@@ -59,14 +59,14 @@
     StringValue(name);
     OSSL_ENGINE_LOAD_IF_MATCH(openssl);
     OSSL_ENGINE_LOAD_IF_MATCH(dynamic);
-    OSSL_ENGINE_LOAD_IF_MATCH(cswift);
-    OSSL_ENGINE_LOAD_IF_MATCH(chil);
-    OSSL_ENGINE_LOAD_IF_MATCH(atalla);
-    OSSL_ENGINE_LOAD_IF_MATCH(nuron);
-    OSSL_ENGINE_LOAD_IF_MATCH(ubsec);
-    OSSL_ENGINE_LOAD_IF_MATCH(aep);
-    OSSL_ENGINE_LOAD_IF_MATCH(sureware);
-    OSSL_ENGINE_LOAD_IF_MATCH(4758cca);
+/*    OSSL_ENGINE_LOAD_IF_MATCH(cswift); */
+/*    OSSL_ENGINE_LOAD_IF_MATCH(chil); */
+/*    OSSL_ENGINE_LOAD_IF_MATCH(atalla); */
+/*    OSSL_ENGINE_LOAD_IF_MATCH(nuron); */
+/*    OSSL_ENGINE_LOAD_IF_MATCH(ubsec); */
+/*    OSSL_ENGINE_LOAD_IF_MATCH(aep); */
+/*    OSSL_ENGINE_LOAD_IF_MATCH(sureware); */
+/*    OSSL_ENGINE_LOAD_IF_MATCH(4758cca); */
 #ifdef HAVE_ENGINE_LOAD_OPENBSD_DEV_CRYPTO
     OSSL_ENGINE_LOAD_IF_MATCH(openbsd_dev_crypto);
 #endif
