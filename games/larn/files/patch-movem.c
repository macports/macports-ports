--- movem.c.orig	1999-11-15 21:57:23.000000000 -0500
+++ movem.c	2006-04-17 21:45:18.000000000 -0400
@@ -217,7 +217,7 @@
 		if (tmp>=DEMONLORD+3) /* demons dispel spheres */
 			{
 			cursors();
-			lprintf("\nThe %s dispels the sphere!",monster[tmp].name);
+			lprintf(2,"\nThe %s dispels the sphere!",monster[tmp].name);
 			rmsphere(cc,dd);	/* delete the sphere */
 			}
 		else i=tmp=mitem[cc][dd]=0;
@@ -256,7 +256,7 @@
 		  case 2: p="\n%s hits and kills the %s";  break;
 		  case 3: p="\nThe %s%s gets teleported"; who="";  break;
 		  };
-		if (p) { lprintf(p,who,monster[tmp].name); beep(); }
+		if (p) { lprintf(2,p,who,monster[tmp].name); beep(); }
 		}
 /*	if (yrepcount>1) { know[aa][bb] &= 2;  know[cc][dd] &= 2; return; } */
 	if (know[aa][bb] & 1)   show1cell(aa,bb);
