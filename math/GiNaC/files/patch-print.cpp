--- ginac/print.cpp.sav	Thu Jan  8 10:06:52 2004
+++ ginac/print.cpp	Fri Oct  8 18:00:00 2004
@@ -29,6 +29,9 @@
 /** Next free ID for print_context types. */
 unsigned next_print_context_id = 0;
 
+template<> print_context_class_info *print_context_class_info::first = NULL;
+template<> bool print_context_class_info::parents_identified = false;
+
 
 GINAC_IMPLEMENT_PRINT_CONTEXT(print_context, void)
 GINAC_IMPLEMENT_PRINT_CONTEXT(print_dflt, print_context)
