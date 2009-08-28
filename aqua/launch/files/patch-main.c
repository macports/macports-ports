--- main.c.orig	2006-10-30 02:56:23.000000000 -0800
+++ main.c	2009-08-28 13:58:09.000000000 -0700
@@ -147,7 +147,7 @@
     len = strlen(errDesc) + 10 * sizeof(char);
     str = (char *)malloc(len);
     if (str != NULL)
-        snprintf(str, len, "%s (%ld)", errDesc, err);
+        snprintf(str, len, "%s (%d)", errDesc, (int)err);
     else
         str = failedStr;
     return str;
@@ -580,7 +580,7 @@
     if (bigSize == 0) {
         if (littleSize == 0) {
             printf("zero bytes on disk (zero bytes used)\n"); return;
-        } else if (littleSize < 1024) printf("%lu bytes", littleSize);
+        } else if (littleSize < 1024) printf("%u bytes", (unsigned int)littleSize);
         else {
             UInt32 adjSize = littleSize >> 10;
             if (adjSize < 1024) printf("%.1f KB", DFORMAT(littleSize));
@@ -594,10 +594,10 @@
             }
         }
     } else {
-        if (bigSize < 256) printf("%lu GB", bigSize);
+        if (bigSize < 256) printf("%u GB", (unsigned int)bigSize);
         else {
             bigSize >>= 2;
-            printf("%lu TB", bigSize);
+            printf("%u TB", (unsigned int)bigSize);
         }
     }
     printf(" on disk (%llu bytes used)\n", logicalSize);
@@ -616,7 +616,7 @@
 	switch (fscInfo.valence) {
 	case 0: printf("zero items\n"); break;
 	case 1: printf("1 item\n"); break;
-	default: printf("%lu items\n", fscInfo.valence);
+	default: printf("%u items\n", (unsigned int)fscInfo.valence);
 	}
     } else {
         printSizes("data fork size", fscInfo.dataLogicalSize, fscInfo.dataPhysicalSize, true);
@@ -735,7 +735,7 @@
             printf("unknown (cputype %d, subtype %d)", fat[i].cputype, fat[i].cpusubtype);
             continue;
         }
-        printf(arch->description);
+        printf("%s", arch->description);
     }
     printf("\n");
 }
@@ -880,7 +880,7 @@
 
 	if (version != NULL) {
 	    printf("\tversion: %s", utf8StringFromCFStringRef(version));
-	    if (intVersion != 0) printf(" [0x%lx = %lu]", intVersion, intVersion);
+	    if (intVersion != 0) printf(" [0x%x = %u]", (unsigned int)intVersion, (unsigned int)intVersion);
 	    putchar('\n');
 	    CFRelease(version);
 	}
