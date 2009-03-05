--- F77.pm.orig	2007-04-01 22:40:23.000000000 -0600
+++ F77.pm	2009-03-05 15:32:52.000000000 -0700
@@ -341,10 +341,10 @@
 
 $F77config{Darwin}{GFortran}{Trail_} = 1;
 $F77config{Darwin}{GFortran}{Cflags} = ' ';        # <---need this space!
-$F77config{Darwin}{GFortran}{Link}   = '-L/usr/local/lib -lgfortran';    
-$F77config{Darwin}{GFortran}{Compiler} = 'gfortran';
+$F77config{Darwin}{GFortran}{Link}   = '-L@@PREFIX@@/lib/gcc43 -lgfortran';    
+$F77config{Darwin}{GFortran}{Compiler} = 'gfortran-mp-4.3';
 
-$F77config{Darwin}{DEFAULT}     = 'G77';
+$F77config{Darwin}{DEFAULT}     = 'GFortran';
 
 ############ End of database is here ############ 
 
