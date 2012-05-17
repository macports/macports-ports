--- src/dvdbackup.c.orig	2010-09-16 22:10:04.307951355 +0200
+++ src/dvdbackup.c	2010-09-16 22:19:49.112413564 +0200
@@ -99,7 +99,8 @@
 
 
 static int CheckSizeArray(const int size_array[], int reference, int target) {
-	if ( (size_array[reference]/size_array[target] == 1) &&
+	if ( size_array[target] &&
+			(size_array[reference]/size_array[target] == 1) &&
 			((size_array[reference] * 2 - size_array[target])/ size_array[target] == 1) &&
 			((size_array[reference]%size_array[target] * 3) < size_array[reference]) ) {
 		/* We have a dual DVD with two feature films - now let's see if they have the same amount of chapters*/
@@ -1264,7 +1265,7 @@
 
 	/* Seek to title of first track, which is at (track_no * 32768) + 40 */
 
-	if ( 32808 != lseek(filehandle, 32808, SEEK_SET) ) {
+	if ( 32768 != lseek(filehandle, 32768, SEEK_SET) ) {
 		close(filehandle);
 		fprintf(stderr, _("Cannot seek DVD device %s - check your DVD device\n"), device);
 		return(1);
@@ -1272,10 +1273,16 @@
 
 	/* Read the DVD-Video title */
 
-	if ( 32 != read(filehandle, title, 32)) {
-		close(filehandle);
-		fprintf(stderr, _("Cannot read title from DVD device %s\n"), device);
-		return(1);
+#define DVD_SEC_SIZ 2048
+	{
+		char tempBuf[ DVD_SEC_SIZ ];
+
+		if (DVD_SEC_SIZ != read(filehandle, tempBuf, DVD_SEC_SIZ)) {
+			close(filehandle);
+			fprintf(stderr, _("Cannot read title from DVD device %s\n"), device);
+			return(1);
+		}
+      	snprintf( title, 32, "%s", tempBuf + 40 );
 	}
 
 	/* Terminate the title string */
