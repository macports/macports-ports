--- src/combobox.cpp.orig	Tue Dec 14 08:15:29 2004
+++ src/combobox.cpp	Tue Dec 14 08:16:13 2004
@@ -91,7 +91,9 @@
 
     VALUE vdata = rb_hash_new();
     rb_hash_aset(vdata,rb_str_new2("self"),self);
+#ifndef __APPLE__
     ptr->SetClientData((void*)vdata);
+#endif
 
     DATA_PTR(self) = ptr;
 
