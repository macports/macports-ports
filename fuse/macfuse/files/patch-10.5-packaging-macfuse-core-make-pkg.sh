--- 10.5/packaging/macfuse-core/make-pkg.sh.orig	2007-11-04 12:15:47.000000000 -0700
+++ 10.5/packaging/macfuse-core/make-pkg.sh	2008-07-05 15:31:40.000000000 -0600
@@ -131,7 +131,7 @@
 VOLUME_PATH="/Volumes/$VOLUME_NAME"
 
 # Copy over the package.
-sudo cp -pRX "$OUTPUT_PACKAGE" "$VOLUME_PATH"
+sudo /bin/cp -pRX "$OUTPUT_PACKAGE" "$VOLUME_PATH"
 if [ $? -ne 0 ]
 then
     hdiutil detach "$VOLUME_PATH"
@@ -139,7 +139,7 @@
 fi
 
 # Set the custom icon.
-sudo cp -pRX "$INSTALL_RESOURCES/.VolumeIcon.icns" "$VOLUME_PATH"/.VolumeIcon.icns
+sudo /bin/cp -pRX "$INSTALL_RESOURCES/.VolumeIcon.icns" "$VOLUME_PATH"/.VolumeIcon.icns
 sudo /Developer/Tools/SetFile -a C "$VOLUME_PATH"
 
 # Copy over the license file.

