===================================================================
RCS file: /usr/local/src/cvsroot/nefu/TDK/README.SH,v
retrieving revision 1.1
retrieving revision 1.3
diff -u -r1.1 -r1.3
--- TDK/README.SH	2002/11/26 16:45:21	1.1
+++ TDK/README.SH	2003/11/06 15:52:22	1.3
@@ -2,42 +2,71 @@
 
 INTRODUCTION
 
-    The purpose of this file is to show how to use the nefu Test Development
-Kit (TDK) to develop and debug an external test for use with nefu's built in
-shelltest.
+    The purpose of this file is to show how to use the nefu Test
+    Development Kit (TDK) to develop and debug an external test
+    for use with nefu's built in shelltest.
 
     You must build nefu's main source before you can use this kit.
 
 TEST DEVELOPMENT
 
-    The nefu TDK is used to create a stand alone program that exercises a
-test on a user specified machine.  Once built, the tdk requires the following
-syntax to execute a shelltest:
+    The nefu TDK is used to create a stand alone program that
+    exercises a test on a user specified machine.  Once built, the
+    tdk requires the following syntax to execute a shelltest:
 
-Usage: ./tdk machine ! shelltest [arg ...]
+    Usage: ./tdk machine ! shelltest [arg ...]
 
-    The first argument to the tester program must be the target machine.  The
-second argument must be the '!' character to make nefu execute a shelltest.
-The third argument must be the name of the shelltest. The remainder of the
-arguments are optional and will be passed to the shelltest.  
+    The first argument to the tester program must be the target
+    machine.  The second argument must be the "!" character to make
+    nefu execute a shelltest.  The third argument must be the name
+    of the shelltest.  The shelltest to be called must be in the
+    shelltests directory.  The remainder of the arguments are
+    optional and will be passed to the shelltest.
 
-SHELLTEST LOCATION:
+SHELLTEST LOCATIONS:
 
-    src/nefu/TDK/shelltests for TDK testing
-    ~nefu/shelltests for nefu
+    @PREFIX@/share/doc/nefu/TDK/shelltests
 
-SHELLTEST INPUT
-    
-    preset environment variables:
-	NEFU_MACHINE
-	MEFU_ADDR
+	The tdk will look in a directory called shelltests for
+	external programs to execute.
+
+    ~nefu/shelltests 
+
+	This is the location the main nefu binary looks for external
+	programs.  Put your external programs here for nefu to use.
+
+SHELLTEST INPUT:
     
-    optional arguments.
+    When an external program is called by nefu, it is given
+    information to make use of.  It is given all of the optional
+    arguments, and all of the main binary's environment variables.
+    Additionally, two other environment variables are set:
+    NEFU_MACHINE is the name of the machine as given, and NEFU_ADDR
+    is the IP address that it resolves to.
 
 SHELLTEST OUTPUT
     
-    exit values
-	0, 1, 2
-
-    error messages
-	first line of text preserved
+    Shelltests written for nefu should return a predefined integer
+    value once a result has been determined.  The three valid codes
+    are 0 for T_UP, 1 for T_DOWN, and 2 for T_MAYBE_DOWN.  T_UP is
+    returned if the test was successful.  Any output from the
+    shelltest is ignored.  T_DOWN should be returned if a test
+    fails in a conclusive manner, such as having a connection
+    refused or if the service tested indicates an error.  T_MAYBE_DOWN
+    is generated when the test was unsuccessful, but the point of
+    failure could not be determined, such as when a connection
+    times out.  In the two DOWN cases, the last line of output from
+    the shelltest is preserved for reporting and publishing purposes.
+
+EXAMPLE
+
+    example% ./tdk localhost ! environ.sh
+    ./tdk: test failed: NEFU_MACHINE "localhost" NEFU_ADDR "127.0.0.1"
+
+    The TDK comes with a shelltest, shelltests/environ.sh.  This
+    test is strictly to illustrate shelltest input and output.
+    All this shell script does is report the values of NEFU_MACHINE
+    and NEFU_ADDR, and exit with a T_DOWN code.  T_DOWN is returned
+    so that we can see the shell test's output.  No output is
+    preserved from a T_UP, because no service error message is
+    needed.
