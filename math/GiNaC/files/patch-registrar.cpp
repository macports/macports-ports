--- ginac/registrar.cpp.sav	Thu Jan  8 10:06:52 2004
+++ ginac/registrar.cpp	Fri Oct  8 17:59:44 2004
@@ -38,4 +38,7 @@
 	return registered_class_info::find(class_name)->options.get_unarch_func();
 }
 
+template<> registered_class_info *registered_class_info::first = NULL;
+template<> bool registered_class_info::parents_identified = false;
+
 } // namespace GiNaC
