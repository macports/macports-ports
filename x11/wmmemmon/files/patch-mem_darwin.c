diff -wubrN wmmemmon-0.7.0/src/mem_darwin.c wmmemmon-0.7.0-mac/src/mem_darwin.c
--- src/mem_darwin.c	Wed Dec 31 16:00:00 1969
+++ src/mem_darwin.c	Tue Sep 24 18:44:17 2002
@@ -0,0 +1,48 @@
+/*
+ * mem_darwin.c - module to get memory/swap usages in percent, for Darwin
+ *
+ * Copyright(c) 2002 Landon J. Fuller <landonf@opendarwin.org>
+ *
+ * licensed under the GPL
+ */
+
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include "mem.h"
+
+#include <mach/mach.h>
+
+static mach_port_t host_port;
+static host_size;
+static vm_size_t pagesize;
+
+/* initialize function */
+void mem_init(void)
+{
+    host_port = mach_host_self();
+    host_size = sizeof(vm_statistics_data_t)/sizeof(integer_t);
+    host_page_size(host_port, &pagesize);
+}
+
+
+/* return mem/swap usage in percent 0 to 100 */
+void mem_getusage(int *per_mem, int *per_swap, const struct mem_options *opts)
+{
+    unsigned long long mem_free, mem_total, mem_used;
+    vm_statistics_data_t vm_stat;
+
+    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
+        exit(1);
+    mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
+    mem_free = vm_stat.free_count * pagesize;
+    mem_total = mem_used + mem_free;
+
+    *per_mem = (100 * ((double) mem_free / (double) mem_total));
+    /* XXX Can I get VM statistics from mach (default_pager_info ?) */
+    *per_swap = 0;
+}
