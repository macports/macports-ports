--- F77.pm.orig	Fri Jun 15 14:04:17 2001
+++ F77.pm	Mon May 17 00:18:45 2004
@@ -265,6 +265,15 @@
 $F77config{VMS}{DEFAULT}     = 'Fortran';
 $F77config{VMS}{Fortran}{Compiler} = 'Fortran';
 
+### Darwin ###
+
+# Note, this is DarwinPorts-specific, as is relies on DP to make sure g77
+# is installed prior to this module being installed
+
+$F77config{Darwin}{G77} = $F77config{Generic}{G77};
+$F77config{Darwin}{F2c} = $F77config{Generic}{G77};
+$F77config{Darwin}{DEFAULT} = 'G77';
+
 ############ End of database is here ############ 
 
 =head1 SYNOPSIS
