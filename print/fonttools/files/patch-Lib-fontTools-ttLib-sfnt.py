--- Lib/fontTools/ttLib/sfnt.py	2002-09-11 04:43:18.000000000 +0900
+++ Lib/fontTools/ttLib/sfnt.py.new	2006-10-28 20:19:08.000000000 +0900
@@ -149,6 +149,8 @@
 		
 		checksums[-1] = calcChecksum(directory)
 		checksum = Numeric.add.reduce(checksums)
+		if checksum < 0:
+			checksum += 0x100000000
 		# BiboAfba!
 		checksumadjustment = Numeric.array(0xb1b0afba) - checksum
 		# write the checksum to the file
