--- snmplib/snmp_api.c	11 Jan 2003 01:10:00 -0000	5.30
+++ snmplib/snmp_api.c	14 Jan 2003 14:14:41 -0000	5.31
@@ -402,7 +402,10 @@
         retVal = 2;
     Reqid = retVal;
     snmp_res_unlock(MT_LIBRARY_ID, MT_LIB_REQUESTID);
-    return retVal;
+    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_16BIT_IDS))
+        return (retVal & 0x7fff);	/* mask to 15 bits */
+    else
+        return retVal;
 }
 
 long
@@ -415,7 +418,10 @@
         retVal = 2;
     Msgid = retVal;
     snmp_res_unlock(MT_LIBRARY_ID, MT_LIB_MESSAGEID);
-    return retVal;
+    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_16BIT_IDS))
+        return (retVal & 0x7fff);	/* mask to 15 bits */
+    else
+        return retVal;
 }
 
 long
@@ -428,7 +434,10 @@
         retVal = 2;
     Sessid = retVal;
     snmp_res_unlock(MT_LIBRARY_ID, MT_LIB_SESSIONID);
-    return retVal;
+    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_16BIT_IDS))
+        return (retVal & 0x7fff);	/* mask to 15 bits */
+    else
+        return retVal;
 }
 
 long
@@ -441,7 +450,10 @@
         retVal = 2;
     Transid = retVal;
     snmp_res_unlock(MT_LIBRARY_ID, MT_LIB_TRANSID);
-    return retVal;
+    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_16BIT_IDS))
+        return (retVal & 0x7fff);	/* mask to 15 bits */
+    else
+        return retVal;
 }
 
 void
@@ -692,6 +704,8 @@
 	              NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_PERSISTENT_DIR);
     netsnmp_ds_register_config(ASN_BOOLEAN, "snmp", "noDisplayHint",
 	              NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_NO_DISPLAY_HINT);
+    netsnmp_ds_register_config(ASN_BOOLEAN, "snmp", "16bitIDs",
+	              NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_16BIT_IDS);
 }
 
 void
diff -u -r5.8 -r5.9
--- include/net-snmp/library/default_store.h	12 Dec 2002 19:18:06 -0000	5.8
+++ include/net-snmp/library/default_store.h	14 Jan 2003 14:14:40 -0000	5.9
@@ -59,6 +59,7 @@
 #define NETSNMP_DS_LIB_QUICKE_PRINT        28   
 #define NETSNMP_DS_LIB_DONT_PRINT_UNITS    29 /* don't print UNITS suffix */
 #define NETSNMP_DS_LIB_NO_DISPLAY_HINT     30 /* don't apply DISPLAY-HINTs */
+#define NETSNMP_DS_LIB_16BIT_IDS           31   /* restrict requestIDs, etc to 16-bit values */
 
     /*
      * library integers 
