--- scsilib/libscg/scsi-mac-iokit.c	2009-08-29 15:41:19.000000000 -0700
+++ scsilib/libscg/scsi-mac-iokit.c	2009-08-29 15:42:08.000000000 -0700
@@ -55,7 +55,7 @@
 #include <Carbon/Carbon.h>
 #include <IOKit/IOKitLib.h>
 #include <IOKit/IOCFPlugIn.h>
-#include <IOKit/scsi-commands/SCSITaskLib.h>
+#include <IOKit/scsi/SCSITaskLib.h>
 #include <mach/mach_error.h>
 
 struct scg_local {
