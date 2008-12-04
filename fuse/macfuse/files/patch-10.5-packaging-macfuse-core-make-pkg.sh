--- 10.5/packaging/macfuse-core/make-pkg.sh.old	2008-12-03 15:25:16.000000000 -0800
+++ 10.5/packaging/macfuse-core/make-pkg.sh	2008-12-03 15:25:43.000000000 -0800
@@ -88,7 +88,7 @@
 
 # Copy the uninstall script
 UNINSTALL_DST="$DISTRIBUTION_FOLDER/Library/Filesystems/fusefs.fs/Support/uninstall-macfuse-core.sh"
-sudo cp "$UNINSTALL_SCRIPT" "$UNINSTALL_DST"
+sudo /bin/cp "$UNINSTALL_SCRIPT" "$UNINSTALL_DST"
 sudo chmod 755 "$UNINSTALL_DST"
 sudo chown root:wheel "$UNINSTALL_DST"
 
@@ -131,7 +131,7 @@
 VOLUME_PATH="/Volumes/$VOLUME_NAME"
 
 # Copy over the package.
-sudo cp -pRX "$OUTPUT_PACKAGE" "$VOLUME_PATH"
+sudo /bin/cp -pRX "$OUTPUT_PACKAGE" "$VOLUME_PATH"
 if [ $? -ne 0 ]
 then
     hdiutil detach "$VOLUME_PATH"
@@ -139,14 +139,14 @@
 fi
 
 # Set the custom icon.
-sudo cp -pRX "$INSTALL_RESOURCES/.VolumeIcon.icns" "$VOLUME_PATH"/.VolumeIcon.icns
+sudo /bin/cp -pRX "$INSTALL_RESOURCES/.VolumeIcon.icns" "$VOLUME_PATH"/.VolumeIcon.icns
 sudo /Developer/Tools/SetFile -a C "$VOLUME_PATH"
 
 # Copy over the license file.
-sudo cp "$INSTALL_RESOURCES/License.rtf" "$VOLUME_PATH"/License.rtf
+sudo /bin/cp "$INSTALL_RESOURCES/License.rtf" "$VOLUME_PATH"/License.rtf
 
 # Copy over the CHANGELOG.txt.
-sudo cp "../../../../CHANGELOG.txt" "$VOLUME_PATH"/CHANGELOG.txt
+sudo /bin/cp "../../../../CHANGELOG.txt" "$VOLUME_PATH"/CHANGELOG.txt
 
 # Detach the volume.
 hdiutil detach "$VOLUME_PATH"
