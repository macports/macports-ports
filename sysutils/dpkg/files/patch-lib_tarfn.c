--- lib/tarfn.c.old	Mon Dec 13 16:27:17 2004
+++ lib/tarfn.c	Mon Dec 13 16:27:07 2004
@@ -181,7 +181,9 @@
 			}
 			/* Else, Fall Through */
 		case Directory:
-			h.Name[nameLength - 1] = '\0';
+			if (h.Name[nameLength - 1] == '/') {
+				h.Name[nameLength - 1] = '\0';
+			}
 			status = (*functions->MakeDirectory)(&h);
 			break;
 		case HardLink:
