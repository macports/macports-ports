--- include/log4cpp/Manipulator.hh	2005-06-01 12:07:48.000000000 -0700
+++ Manipulator.hh	2006-01-30 14:24:43.000000000 -0800
@@ -26,5 +26,5 @@
 inline	tab(unsigned int i) : size(i) {}
 friend LOG4CPP_EXPORT std::ostream& operator<< (std::ostream& os, const tab& w);
 	};
-};
+}
 #endif
