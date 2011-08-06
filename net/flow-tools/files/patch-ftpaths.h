--- lib/ftpaths.h.orig	Wed Dec  3 22:19:47 2003
+++ lib/ftpaths.h	Wed Jul  7 15:06:42 2004
@@ -29,17 +29,17 @@
 #ifndef FTPATHS_H
 #define FTPATHS_H
 
-#define FT_PATH_CFG_MAP             "/usr/local/netflow/var/cfg/map.cfg"
-#define FT_PATH_CFG_TAG             "/usr/local/netflow/var/cfg/tag.cfg"
-#define FT_PATH_CFG_FILTER          "/usr/local/netflow/var/cfg/filter.cfg"
-#define FT_PATH_CFG_STAT            "/usr/local/netflow/var/cfg/stat.cfg"
-#define FT_PATH_CFG_MASK            "/usr/local/netflow/var/cfg/mask.cfg"
-#define FT_PATH_CFG_XLATE           "/usr/local/netflow/var/cfg/xlate.cfg"
+#define FT_PATH_CFG_MAP             "__PREFIX__/etc/flow-tools/map.cfg"
+#define FT_PATH_CFG_TAG             "__PREFIX__/etc/flow-tools/tag.cfg"
+#define FT_PATH_CFG_FILTER          "__PREFIX__/etc/flow-tools/filter.cfg"
+#define FT_PATH_CFG_STAT            "__PREFIX__/etc/flow-tools/stat.cfg"
+#define FT_PATH_CFG_MASK            "__PREFIX__/etc/flow-tools/mask.cfg"
+#define FT_PATH_CFG_XLATE           "__PREFIX__/etc/flow-tools/xlate.cfg"
 
-#define FT_PATH_SYM_IP_PROT         "/usr/local/netflow/var/sym/ip-prot.sym"
-#define FT_PATH_SYM_IP_TYPE         "/usr/local/netflow/var/sym/ip-type.sym"
-#define FT_PATH_SYM_TCP_PORT        "/usr/local/netflow/var/sym/tcp-port.sym"
-#define FT_PATH_SYM_ASN             "/usr/local/netflow/var/sym/asn.sym"
-#define FT_PATH_SYM_TAG             "/usr/local/netflow/var/sym/tag.sym"
+#define FT_PATH_SYM_IP_PROT         "__PREFIX__/share/flow-tools/ip-prot.sym"
+#define FT_PATH_SYM_IP_TYPE         "__PREFIX__/share/flow-tools/ip-type.sym"
+#define FT_PATH_SYM_TCP_PORT        "__PREFIX__/share/flow-tools/tcp-port.sym"
+#define FT_PATH_SYM_ASN             "__PREFIX__/share/flow-tools/asn.sym"
+#define FT_PATH_SYM_TAG             "__PREFIX__/share/flow-tools/tag.sym"
 
 #endif /* FTPATHS_H */
--- lib/ftpaths.h.in.orig	Tue Nov 11 08:49:14 2003
+++ lib/ftpaths.h.in	Wed Jul  7 15:05:45 2004
@@ -29,17 +29,17 @@
 #ifndef FTPATHS_H
 #define FTPATHS_H
 
-#define FT_PATH_CFG_MAP             "@localstatedir@/cfg/map.cfg"
-#define FT_PATH_CFG_TAG             "@localstatedir@/cfg/tag.cfg"
-#define FT_PATH_CFG_FILTER          "@localstatedir@/cfg/filter.cfg"
-#define FT_PATH_CFG_STAT            "@localstatedir@/cfg/stat.cfg"
-#define FT_PATH_CFG_MASK            "@localstatedir@/cfg/mask.cfg"
-#define FT_PATH_CFG_XLATE           "@localstatedir@/cfg/xlate.cfg"
+#define FT_PATH_CFG_MAP             "@localstatedir@/etc/flow-tools/map.cfg"
+#define FT_PATH_CFG_TAG             "@localstatedir@/etc/flow-tools/tag.cfg"
+#define FT_PATH_CFG_FILTER          "@localstatedir@/etc/flow-tools/filter.cfg"
+#define FT_PATH_CFG_STAT            "@localstatedir@/etc/flow-tools/stat.cfg"
+#define FT_PATH_CFG_MASK            "@localstatedir@/etc/flow-tools/mask.cfg"
+#define FT_PATH_CFG_XLATE           "@localstatedir@/etc/flow-tools/xlate.cfg"
 
-#define FT_PATH_SYM_IP_PROT         "@localstatedir@/sym/ip-prot.sym"
-#define FT_PATH_SYM_IP_TYPE         "@localstatedir@/sym/ip-type.sym"
-#define FT_PATH_SYM_TCP_PORT        "@localstatedir@/sym/tcp-port.sym"
-#define FT_PATH_SYM_ASN             "@localstatedir@/sym/asn.sym"
-#define FT_PATH_SYM_TAG             "@localstatedir@/sym/tag.sym"
+#define FT_PATH_SYM_IP_PROT         "@localstatedir@/share/flow-tools/ip-prot.sym"
+#define FT_PATH_SYM_IP_TYPE         "@localstatedir@/share/flow-tools/ip-type.sym"
+#define FT_PATH_SYM_TCP_PORT        "@localstatedir@/share/flow-tools/tcp-port.sym"
+#define FT_PATH_SYM_ASN             "@localstatedir@/share/flow-tools/asn.sym"
+#define FT_PATH_SYM_TAG             "@localstatedir@/share/flow-tools/tag.sym"
 
 #endif /* FTPATHS_H */
