--- zeroinstall/injector/arch.py.orig	2006-10-08 08:14:49.000000000 -0400
+++ zeroinstall/injector/arch.py	2006-11-11 12:30:07.000000000 -0500
@@ -42,6 +42,7 @@
 		'i486': ['i386'],
 		'i586': ['i486', 'i386'],
 		'i686': ['i586', 'i486', 'i386'],
+		'x86_64': ['i686', 'i586', 'i486', 'i386'],
 		'ppc64': ['ppc32'],
 	}
 	for supported in _machine_matrix.get(this_machine, []):
