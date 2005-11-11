--- gcc/version.c.orig	Wed Mar 23 15:03:34 2005
+++ gcc/version.c	Wed Mar 23 15:05:43 2005
@@ -16,7 +16,9 @@
      to get version number string. Do not use new line.
 */
 
-const char version_string[] = "4.0.0 20041026 (Apple Computer, Inc. build 4062)";
+/* Modified to reflect that this is a DarwinPorts build, not an Apple build */
+
+const char version_string[] = "4.0.0 20041026 (Apple Computer, Inc. build 4062) (from DarwinPorts)";
 /* APPLE LOCAL end Apple version */
 
 /* This is the location of the online document giving instructions for
@@ -27,5 +29,5 @@
    not bugs in your modifications.)  */
 
 /* APPLE LOCAL begin Apple bug-report */
-const char bug_report_url[] = "<URL:http://developer.apple.com/bugreporter>";
+const char bug_report_url[] = "<URL:http://bugzilla.opendarwin.org/enter_bug.cgi?product=DarwinPorts&component=dports>";
 /* APPLE LOCAL end Apple bug-report */
