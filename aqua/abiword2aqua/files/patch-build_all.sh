--- build_all.sh.org	Sat Jan  1 14:25:24 2005
+++ build_all.sh	Sat Jan  1 14:25:32 2005
@@ -217,23 +217,3 @@
 (cd abidistfiles/templates; tar cf $SYMROOT/tmp-templates.tar *awt*; cd $SYMROOT/AbiWord.app/Contents/Resources; /bin/rm -rf templates; mkdir templates; cd templates; tar xf $SYMROOT/tmp-templates.tar; rm $SYMROOT/tmp-templates.tar)
 
 rm -f $SYMROOT/AbiWord.dmg
-
-hdiutil create -megabytes 30 -fs HFS+ -volname AbiWord $SYMROOT/AbiWord.dmg
-device_name=`hdiutil attach $SYMROOT/AbiWord.dmg | grep "/Volumes/" | cut -f 1 -d " "`
-if test -z $device_name; then
-	echo "error: unable to mount $SYMROOT/AbiWord.dmg"
-else
-	echo "$SYMROOT/AbiWord.dmg mounted as $device_name"
-	cp -RP $SYMROOT/AbiWord.app /Volumes/AbiWord/
-	cp COPYING /Volumes/AbiWord/COPYING.txt
-#	cp README-MacOSX.pdf /Volumes/AbiWord/
-	mkdir /Volumes/AbiWord/InvisibleAnt
-	mkdir /Volumes/AbiWord/InvisibleAnt/images
-	/Developer/Tools/SetFile -a V /Volumes/AbiWord/InvisibleAnt
-	cp abipbx/AbiWord-DMG-ReadMe/README.html /Volumes/AbiWord/
-	cp abipbx/AbiWord-DMG-ReadMe/InvisibleAnt/*.* /Volumes/AbiWord/InvisibleAnt/
-	cp abipbx/AbiWord-DMG-ReadMe/InvisibleAnt/images/*.* /Volumes/AbiWord/InvisibleAnt/images/
-	cp abipbx/AbiWord-DMG-Background.png /Volumes/AbiWord/InvisibleAnt/
-	cp abipbx/AbiWord-DMG-DS_Store /Volumes/AbiWord/.DS_Store
-	hdiutil detach $device_name
-fi
