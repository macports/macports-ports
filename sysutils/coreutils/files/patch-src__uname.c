--- src/uname.c.orig	Wed Jan 21 17:27:02 2004
+++ src/uname.c	Sat Oct 23 04:37:29 2004
@@ -44,6 +44,11 @@
 # endif
 #endif
 
+#if defined(__APPLE__)
+#include <mach/machine.h>
+#include <mach-o/arch.h>
+#endif
+
 #include "system.h"
 #include "error.h"
 
@@ -258,6 +263,21 @@
 	  static int mib[] = { CTL_HW, UNAME_PROCESSOR };
 	  if (sysctl (mib, 2, processor, &s, 0, 0) >= 0)
 	    element = processor;
+	}
+#endif
+#if defined(__APPLE__)
+	if (element == unknown)
+	{
+		cpu_type_t cputype;
+		size_t s = sizeof cputype;
+		NXArchInfo *ai;
+		if (sysctlbyname("hw.cputype", &cputype, &s, NULL, 0) == 0)
+			if ((ai = NXGetArchInfoFromCpuType(cputype, CPU_SUBTYPE_MULTIPLE)) != NULL)
+				element = ai->name;
+
+		/* Hack "safely" around the ppc vs. powerpc return value. */
+		if (cputype == CPU_TYPE_POWERPC && !strncmp(element, "ppc", 3))
+			element = "powerpc";
 	}
 #endif
       print_element (element);
