--- extract.sh.orig	2007-05-28 09:32:38.000000000 -0400
+++ extract.sh	2007-05-28 09:35:10.000000000 -0400
@@ -44,7 +44,7 @@
 
 
 
-if [ "`tar --help | grep -- --strip-components 2> /dev/null`" ]; then
+if [ "`gnutar --help | grep -- --strip-components 2> /dev/null`" ]; then
     TARSTRIP=--strip-components
 else
     TARSTRIP=--strip-path
@@ -62,9 +62,9 @@
 fi
 
 mkdir -p ${DISTDIR}
-tar ${TARSTRIP}=1 -jxf ${CCTOOLSDISTFILE} -C ${DISTDIR}
+gnutar ${TARSTRIP}=1 -jxf ${CCTOOLSDISTFILE} -C ${DISTDIR}
 mkdir -p ${DISTDIR}/ld64
-tar ${TARSTRIP}=1 -jxf ${LD64DISTFILE} -C ${DISTDIR}/ld64
+gnutar ${TARSTRIP}=1 -jxf ${LD64DISTFILE} -C ${DISTDIR}/ld64
 find ${DISTDIR}/ld64/doc/ -type f -exec cp "{}" ${DISTDIR}/man \;
 
 # Clean the source a bit
@@ -81,7 +81,7 @@
 
     mv ${DISTDIR}/include/mach/machine.h ${DISTDIR}/include/mach/machine.h.new;
     for i in mach architecture i386 libkern; do
-	tar cf - -C "$SDKROOT/usr/include" $i | tar xf - -C ${DISTDIR}/include
+	gnutar cf - -C "$SDKROOT/usr/include" $i | gnutar xf - -C ${DISTDIR}/include
     done
     mv ${DISTDIR}/include/mach/machine.h.new ${DISTDIR}/include/mach/machine.h;
 
@@ -135,7 +135,7 @@
 set -e
 
 echo "Adding new files"
-tar cf - --exclude=CVS --exclude=.svn -C ${ADDEDFILESDIR} . | tar xvf - -C ${DISTDIR}
+gnutar cf - --exclude=CVS --exclude=.svn -C ${ADDEDFILESDIR} . | gnutar xvf - -C ${DISTDIR}
 
 echo "Deleting cruft"
 find ${DISTDIR} -name Makefile -exec rm -f "{}" \;
@@ -151,7 +151,7 @@
 if [ $MAKEDISTFILE -eq 1 ]; then
     DATE=$(date +%Y%m%d)
     mv ${DISTDIR} ${DISTDIR}-$DATE
-    tar jcf ${DISTDIR}-$DATE.tar.bz2 ${DISTDIR}-$DATE
+    gnutar jcf ${DISTDIR}-$DATE.tar.bz2 ${DISTDIR}-$DATE
 fi
 
 exit 0
