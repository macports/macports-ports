--- x.c.orig	Thu Sep  5 01:24:30 2002
+++ x.c
@@ -959,6 +959,11 @@ bytes_per_pixel_found:
 						case 15:
 						case 16:
 						if (x_bitmap_bpp!=2)break;
+						if (x_bitmap_bit_order==MSBFirst&&vinfo.red_mask>vinfo.green_mask&&vinfo.green_mask>vinfo.blue_mask)
+						{
+							misordered=256;
+							goto visual_found;
+						}
 						if (x_bitmap_bit_order==MSBFirst)break;
 						if (vinfo.red_mask>vinfo.green_mask&&vinfo.green_mask>vinfo.blue_mask)
 						{
@@ -974,14 +987,14 @@ bytes_per_pixel_found:
 							misordered=256;
 							goto visual_found;
 						}
-						if (vinfo.red_mask>vinfo.green_mask&&vinfo.green_mask>vinfo.blue_mask)
+						if (x_bitmap_bit_order==MSBFirst&&vinfo.red_mask>vinfo.green_mask&&vinfo.green_mask>vinfo.blue_mask)
 						{
-							misordered=0;
+							misordered=512;
 							goto visual_found;
 						}
-						if (x_bitmap_bit_order==MSBFirst&&vinfo.red_mask>vinfo.green_mask&&vinfo.green_mask>vinfo.blue_mask)
+						if (vinfo.red_mask>vinfo.green_mask&&vinfo.green_mask>vinfo.blue_mask)
 						{
-							misordered=512;
+							misordered=0;
 							goto visual_found;
 						}
 						break;
@@ -1010,6 +1023,7 @@ visual_found:;
 		case 451:
 		case 195:
 		case 196:
+		case 386:
 		case 452:
 		case 708:
 /* 			printf("depth=%d visualid=%x\n",x_driver.depth, vinfo.visualid); */
