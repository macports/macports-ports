--- src/stackvma-mach.c.orig	2009-07-26 16:54:18.000000000 -0700
+++ src/stackvma-mach.c	2009-07-26 16:54:21.000000000 -0700
@@ -53,7 +53,7 @@
   for (address = VM_MIN_ADDRESS; more; address += size)
     {
 #ifdef VM_REGION_BASIC_INFO
-      more = (vm_region (task, &address, &size, VM_REGION_BASIC_INFO,
+      more = (vm_region_64 (task, &address, &size, VM_REGION_BASIC_INFO,
                          (vm_region_info_t)&info, &info_count, &object_name)
               == KERN_SUCCESS);
 #else
