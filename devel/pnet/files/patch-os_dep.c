--- libgc/os_dep.c.org	2005-06-21 09:51:54.000000000 +0200
+++ libgc/os_dep.c	2005-06-21 09:52:41.000000000 +0200
@@ -3407,7 +3407,7 @@
 
 #define MAX_EXCEPTION_PORTS 16
 
-static mach_port_t GC_task_self;
+mach_port_t GC_task_self;
 
 static struct {
     mach_msg_type_number_t count;
