--- ginac/class_info.h.sav	Thu Jan  8 10:06:47 2004
+++ ginac/class_info.h	Fri Oct  8 17:59:25 2004
@@ -87,7 +87,7 @@
 	// on the first trip through this function.
 	typedef std::map<std::string, const class_info *> name_map_type;
 	static name_map_type name_map;
-	static bool name_map_initialized = false;
+	static bool name_map_initialized;
 
 	if (!name_map_initialized) {
 		// Construct map
@@ -191,6 +191,7 @@
 
 template <class OPT> class_info<OPT> *class_info<OPT>::first = NULL;
 template <class OPT> bool class_info<OPT>::parents_identified = false;
+
 
 } // namespace GiNaC
 
