diff -rwubN wmcpuload-1.0.0/src/cpu_darwin.c wmcpuload-1.0.0-darwin/src/cpu_darwin.c
--- src/cpu_darwin.c	Wed Dec 31 16:00:00 1969
+++ src/cpu_darwin.c	Tue Sep 24 08:55:27 2002
@@ -0,0 +1,58 @@
+/*
+ * cpu_darwin - module to get cpu usage, for Darwin
+ *
+ * Copyright (C) 2001, 2002 Seiichi SATO <ssato@sh.rim.or.jp>
+ *
+ * Licensed under the GPL
+ */
+
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include "cpu.h"
+
+#include <mach/host_info.h>
+#include <mach/mach_types.h>
+#include <mach/message.h>
+
+static host_cpu_load_info_data_t prevcount, curcount;
+static mach_port_t host_priv_port;
+
+static
+getload(host_cpu_load_info_t cpucounters)
+{
+    mach_msg_type_number_t count;
+    kern_return_t kr;
+    count = HOST_CPU_LOAD_INFO_COUNT;
+    kr = host_statistics (host_priv_port, HOST_CPU_LOAD_INFO, (host_info_t) cpucounters, &count);
+    return (kr);
+}
+
+void
+cpu_init(void)
+{
+    host_priv_port = mach_host_self();
+    getload(&prevcount);
+    return;
+}
+
+/* Returns the current CPU usage in percent */
+int
+cpu_get_usage(cpu_options *opts)
+{
+    double userticks, systicks, idleticks, totalticks, usedticks;
+    getload(&curcount);
+
+    userticks = curcount.cpu_ticks[CPU_STATE_USER] - prevcount.cpu_ticks[CPU_STATE_USER];
+    systicks = curcount.cpu_ticks[CPU_STATE_SYSTEM] - prevcount.cpu_ticks[CPU_STATE_SYSTEM];
+    idleticks = curcount.cpu_ticks[CPU_STATE_IDLE] - prevcount.cpu_ticks[CPU_STATE_IDLE];
+    prevcount = curcount;
+    usedticks = userticks + systicks;
+    totalticks = usedticks + idleticks;
+    return ((100 * (double) usedticks) / totalticks);
+}
