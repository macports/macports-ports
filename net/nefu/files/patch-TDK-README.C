===================================================================
RCS file: /usr/local/src/cvsroot/nefu/TDK/README.C,v
retrieving revision 1.2
retrieving revision 1.3
diff -u -r1.2 -r1.3
--- TDK/README.C	2002/11/26 16:26:35	1.2
+++ TDK/README.C	2003/11/04 16:52:28	1.3
@@ -3,123 +3,128 @@
 INTRODUCTION
 
     The purpose of this file is to show a C programmer how to use the nefu
-Test Development Kit (TDK) to develop and debug a binary nefu test.  Tests
-developed with the TDK can be quickly integrated in to the main nefu source.
+    Test Development Kit (TDK) to develop and debug a binary nefu test.
+    Tests developed with the TDK can be quickly integrated in to the main
+    nefu source.
 
     You must build nefu's main source before you can use this kit.
 
 TEST DEVELOPMENT
 
     The nefu TDK is used to create a stand alone program that exercises a
-test on a user specified machine.  Once built, the tdk requires the following
-syntax:
+    test on a user specified machine.  Once built, the tdk requires the
+    following syntax:
 
-Usage: ./tdk machine test [arg ...]
+    Usage: ./tdk machine test [arg ...]
 
     The first argument to the tester program must be the target machine.  The
-second argument must be the test we wish to execute.  The remainder of the
-arguments are optional and will be passed to the test.
+    second argument must be the test we wish to execute.  The remainder of
+    the arguments are optional and will be passed to the test.
 
     All nefu tests have an initilization function and a test function.  The
-initilization function is responsable for test argument checking and useage,
-the test function is where protocol transaction code resides.
+    initilization function is responsable for test argument checking and
+    useage, the test function is where protocol transaction code resides.
 
 INITILIZATION FUNCTION
 
     Most nefu tests do not require arguments and should simply use the built
-in function init_noargs.  Tests with arguments need their own initilization
-routine to insure that they're used properly.  The prototype that a test's
-initilization routine must conform to is as follows:
+    in function init_noargs.  Tests with arguments need their own
+    initilization routine to insure that they're used properly.  The
+    prototype that a test's initilization routine must conform to is as
+    follows:
 
 char *init_mytest( struct test *t );
 
     Initilization routines return a NULL string if test t's arguments conform
-to it's useage.  If there was an input error, init_mytest should return a
-test useage description.
+    to it's useage.  If there was an input error, init_mytest should return a
+    test useage description.
 
 TEST FUNCTION
 
     To create a new test for nefu, modify the function test_tdk located in
-tdk.c.  It's prototype is as follows:
+    tdk.c.  It's prototype is as follows:
 
-int test_tdk( struct test *t, struct report *r );
+    int test_tdk( struct test *t, struct report *r );
 
     All tests written for nefu are two argument functions.  The first
-argument, struct test *t, contains optional arguments and internet
-information for the target.  The second argument, struct report *r, is used
-for error message reporting.
+    argument, struct test *t, contains optional arguments and internet
+    information for the target.  The second argument, struct report *r, is
+    used for error message reporting.
 
     Tests written for nefu should return a predefined integer value once a
-result has been determined.  The three valid codes are T_UP, T_DOWN, and
-T_MAYBE_DOWN.  T_UP is returned if the test was successful.  T_DOWN should be
-returned if a test fails in a conclusive manner, such as having a connection
-refused or if the service tested indicates an error.  T_MAYBE_DOWN is
-generated when the test was unsuccessful, but the point of failure could not
-be determined, such as when a connection times out.
+    result has been determined.  The three valid codes are T_UP, T_DOWN, and
+    T_MAYBE_DOWN.  T_UP is returned if the test was successful.  T_DOWN
+    should be returned if a test fails in a conclusive manner, such as having
+    a connection refused or if the service tested indicates an error.
+    T_MAYBE_DOWN is generated when the test was unsuccessful, but the point
+    of failure could not be determined, such as when a connection times out.
 
     Tests written for nefu must return programatic control back to their
-parent function.  Tests may not contain exit calls.  Programatically unsound
-tests integrated in the main nefu source have the potential to cause
-monitoring outages.
+    parent function.  Tests may not contain exit calls.  Programatically
+    unsound tests integrated in the main nefu source have the potential to
+    cause monitoring outages.
 
     In the event of a system error, such as the failure of a support function
-or system call, the error text should reported via the reporting API and the
-function should return T_MAYBE_DOWN.
+    or system call, the error text should reported via the reporting API and
+    the function should return T_MAYBE_DOWN.
 
 THE TEST STRUCTURE
 
-#include <sys/types.h>
-#include <netinet/in.h>
-#include "nefu.h"
-
-struct test {
-    char		*t_name
-    struct machine	*t_machine;
-    char		*t_argv[];
-    int			t_argc;
-    struct sockaddr_in	t_sin;
-};
+    #include <sys/types.h>
+    #include <netinet/in.h>
+    #include "nefu.h"
+
+    struct test {
+	char			*t_name
+	struct machine		*t_machine;
+	char			*t_argv[];
+	int			t_argc;
+	struct sockaddr_in	t_sin;
+    };
 
     The test data structure contains information that is nessecary in writing
-nefu tests.  t_name conatins that name of the test.  t_machine is a pointer
-to the test's machine structure, detailed below.  t_argc and t_argv[] are
-test argument counters and vector, respectively.  t_sin is a sockaddr_in
-filled with the machine's address and the test's port.
-
-struct machine {
-    char		*m_name;
-};
+    nefu tests.  t_name conatins that name of the test.  t_machine is a
+    pointer to the test's machine structure, detailed below.  t_argc and
+    t_argv[] are test argument counters and vector, respectively.  t_sin is a
+    sockaddr_in filled with the machine's address and the test's port.
+
+    struct machine {
+	char			*m_name;
+    };
 
     The only item of interest in the machine structure is m_name, the name of
-the machine we are testing.
+    the machine we are testing.
 
 ERROR REPORTING & THE REPORT STRUCTURE
 
 int report_printf( struct report *r, char *fmt, ... );
 
     The report_printf() function is used to report diagnostic error messages
-in the event of a system error or test failure.  For nefu test authoring
-purposes, simply use the report structure provided as report_printf's first
-argument.  fmt is a control string similar to the printf format string.
-Currently only %s, %m, and %d are supported.  Additional arguments should be
-variables appropriate for their placeholders in the format string.
+    in the event of a system error or test failure.  For nefu test authoring
+    purposes, simply use the report structure provided as report_printf's
+    first argument.  fmt is a control string similar to the printf format
+    string.  Currently only %s, %m, and %d are supported.  Additional
+    arguments should be variables appropriate for their placeholders in the
+    format string.
 
     Additional information, such as performance statistics, may be logged via
-syslog.
+    syslog.
 
 TIME SUPPORT FUNCTIONS
 
-int time_start( struct timeval *tv );
-int time_end( struct timeval *tv );
-int time_minus( struct timeval *total, struct timeval *minus );
+    int time_start( struct timeval *tv );
+    int time_end( struct timeval *tv );
+    int time_minus( struct timeval *total, struct timeval *minus );
 
     The duration of an event can be timed using time_start and time_end.
-time_end will modify a timeval to show how much time has passed since it was
-initilized with time_start.  time_minus subtracts the ammount of time
-contained in the minus structure from the total.  All time functions return 0
-if successful, -1 if there is a system failure or a value out of range.
+    time_end will modify a timeval to show how much time has passed since it
+    was initilized with time_start.  time_minus subtracts the ammount of time
+    contained in the minus structure from the total.  All time functions
+    return 0 if successful, -1 if there is a system failure or a value out of
+    range.
 
 TEST DEVELOPMENT IN THE TDK SOURCE:
+
     Create a test for nefu, use ldap as an example:
 
     1.  ttable.c:
@@ -168,7 +173,7 @@
 SIMPLE TEST INTEGRATION (NO ADDITIONAL LIBRARIES):
 
     Tests created with the TDK can be easily integrated in to nefu's main
-source by following the example below.
+    source by following the example below.
 
     1.  From nefu's main source directory, copy and rename the new test's
 	    source file from the TDK to libtest.  Note that we have used the
