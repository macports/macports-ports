--- src/gc.cpp.org	2005-05-16 09:08:08.000000000 +0200
+++ src/gc.cpp	2005-05-16 09:12:12.000000000 +0200
@@ -187,7 +187,6 @@
         ops = enabled_ops;
     }
 
-    if ( ops.malloc != std::malloc ) {
         GC_no_dls = 1;
         GC_all_interior_pointers = 1;
         GC_finalize_on_demand = 0;
@@ -195,7 +194,6 @@
         GC_INIT();
 
         GC_set_warn_proc(&display_warning);
-    }
 }
 
 }
