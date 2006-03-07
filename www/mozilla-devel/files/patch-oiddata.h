--- security/nss/lib/pki1/oiddata.h.orig	2006-03-05 13:24:38.000000000 -0500
+++ security/nss/lib/pki1/oiddata.h	2006-03-05 13:26:33.000000000 -0500
@@ -43,7 +43,7 @@
 #include "nsspki1t.h"
 #endif /* NSSPKI1T_H */
 
-extern const NSSOID nss_builtin_oids[];
+extern const NSSOID *nss_builtin_oids;
 extern const PRUint32 nss_builtin_oid_count;
 
 /*extern const nssAttributeTypeAliasTable nss_attribute_type_aliases[];*/
