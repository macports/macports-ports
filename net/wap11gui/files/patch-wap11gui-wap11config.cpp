--- wap11gui/wap11config.cpp.orig	Fri Feb  6 20:10:58 2004
+++ wap11gui/wap11config.cpp	Fri Feb  6 20:16:43 2004
@@ -36,9 +36,9 @@ WAP11Config::WAP11Config()
 {
   init_snmp("WAP11-SNMP");
   add_mibdir(MIBSDIR);
-  init_mib_internals();
+  netsnmp_init_mib_internals();
   snmp_sess_init(&session);
-  if(read_module("ATMEL-MIB")==0)
+  if(netsnmp_read_module("ATMEL-MIB")==0)
   {
     THROW_WAP11_EXCEPTION( WAP11SNMPAuthError );
   }
@@ -549,10 +549,10 @@
 {
   char s[16];
   sprintf(s, "%d.%d.%d.%d",
-          (unsigned char)(ipa&0xff),
-          (unsigned char)((ipa&0xff00)>>8),
+          (unsigned char)((ipa&0xff000000)>>24),
           (unsigned char)((ipa&0xff0000)>>16),
-          (unsigned char)((ipa&0xff000000)>>24));
+          (unsigned char)((ipa&0xff00)>>8),
+          (unsigned char)(ipa&0xff));
   std::string ret(s);
   return ret;
 }
