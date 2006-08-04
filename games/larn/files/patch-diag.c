--- diag.c.orig	2002-05-30 17:04:11.000000000 -0400
+++ diag.c	2006-04-17 22:24:21.000000000 -0400
@@ -31,10 +31,10 @@
 
 /*	for the character attributes	*/
 
-	lprintf("\n\nPlayer attributes:\n\nHit points: %2d(%2d)",(long)c[HP],(long)c[HPMAX]);
-	lprintf("\ngold: %d  Experience: %d  Character level: %d  Level in caverns: %d",
+	lprintf(3,"\n\nPlayer attributes:\n\nHit points: %2d(%2d)",(long)c[HP],(long)c[HPMAX]);
+	lprintf(5,"\ngold: %d  Experience: %d  Character level: %d  Level in caverns: %d",
 		(long)c[GOLD],(long)c[EXPERIENCE],(long)c[LEVEL],(long)level);
-	lprintf("\nTotal types of monsters: %d",(long)MAXMONST+8);
+	lprintf(2,"\nTotal types of monsters: %d",(long)MAXMONST+8);
 
 	lprcat("\f\nHere's the dungeon:\n\n");
 
@@ -42,7 +42,7 @@
 	for (j=0; j<MAXLEVEL+MAXVLEVEL; j++)
 		{
 		newcavelevel(j);
-		lprintf("\nMaze for level %s:\n",levelname[level]);
+		lprintf(2,"\nMaze for level %s:\n",levelname[level]);
 		diagdrawscreen();
 		}
 	newcavelevel(i);
@@ -52,9 +52,9 @@
 	lprcat("--------------------------------------------------------------------------\n");
 	for (i=0; i<=MAXMONST+8; i++)
 		{
-		lprintf("%19s  %2d  %3d ",monster[i].name,(long)monster[i].level,(long)monster[i].armorclass);
-		lprintf(" %3d  %3d  %3d  ",(long)monster[i].damage,(long)monster[i].attack,(long)monster[i].defense);
-		lprintf("%6d  %3d   %6d\n",(long)monster[i].gold,(long)monster[i].hitpoints,(long)monster[i].experience);
+		lprintf(4,"%19s  %2d  %3d ",monster[i].name,(long)monster[i].level,(long)monster[i].armorclass);
+		lprintf(4," %3d  %3d  %3d  ",(long)monster[i].damage,(long)monster[i].attack,(long)monster[i].defense);
+		lprintf(4,"%6d  %3d   %6d\n",(long)monster[i].gold,(long)monster[i].hitpoints,(long)monster[i].experience);
 		}
 
 	lprcat("\n\nHere's a Table for the to hit percentages\n");
@@ -70,7 +70,7 @@
 		{
 		hit = 2*monster[i].armorclass+2*monster[i].level+16;
 		dam = 16 - c[HARDGAME];
-		lprintf("\n%20s   %2d/%2d/%2d       %2d/%2d/%2d       %2d/%2d/%2d",
+		lprintf(11,"\n%20s   %2d/%2d/%2d       %2d/%2d/%2d       %2d/%2d/%2d",
 					monster[i].name,
 					(long)(hit/2),(long)max(0,dam+2),(long)(monster[i].hitpoints/(dam+2)+1),
 					(long)((hit+2)/2),(long)max(0,dam+10),(long)(monster[i].hitpoints/(dam+10)+1),
@@ -78,22 +78,22 @@
 		}
 
 	lprcat("\n\nHere's the list of available potions:\n\n");
-	for (i=0; i<MAXPOTION; i++)	lprintf("%20s\n",&potionname[i][1]);
+	for (i=0; i<MAXPOTION; i++)	lprintf(2,"%20s\n",&potionname[i][1]);
 	lprcat("\n\nHere's the list of available scrolls:\n\n");
-	for (i=0; i<MAXSCROLL; i++)	lprintf("%20s\n",&scrollname[i][1]);
+	for (i=0; i<MAXSCROLL; i++)	lprintf(2,"%20s\n",&scrollname[i][1]);
 	lprcat("\n\nHere's the spell list:\n\n");
 	lprcat("spell          name           description\n");
 	lprcat("-------------------------------------------------------------------------------------------\n\n");
 	for (j=0; j<SPNUM; j++)
 		{
 		lprc(' ');	lprcat(spelcode[j]);
-		lprintf(" %21s  %s\n",spelname[j],speldescript[j]);
+		lprintf(3," %21s  %s\n",spelname[j],speldescript[j]);
 		}
 
 	lprcat("\n\nFor the c[] array:\n");
 	for (j=0; j<100; j+=10)
 		{
-		lprintf("\nc[%2d] = ",(long)j); for (i=0; i<9; i++) lprintf("%5d ",(long)c[i+j]);
+		lprintf(2,"\nc[%2d] = ",(long)j); for (i=0; i<9; i++) lprintf(2,"%5d ",(long)c[i+j]);
 		}
 
 	lprcat("\n\nTest of random number generator ----------------");
@@ -101,7 +101,7 @@
 
 	for (i=0; i<16; i++)  rndcount[i]=0;
 	for (i=0; i<25000; i++)	rndcount[rund(16)]++;
-	for (i=0; i<16; i++)  { lprintf("  %5d",(long)rndcount[i]); if (i==7) lprc('\n'); }
+	for (i=0; i<16; i++)  { lprintf(2,"  %5d",(long)rndcount[i]); if (i==7) lprc('\n'); }
 
 	lprcat("\n\n");			lwclose();
 	lcreat((char*)0);		lprcat("Done Diagnosing . . .");
@@ -155,7 +155,7 @@
 	ointerest();
 	if (lcreat(fname) < 0)
 		{
-		lcreat((char*)0); lprintf("\nCan't open file <%s> to save game\n",fname);
+		lcreat((char*)0); lprintf(2,"\nCan't open file <%s> to save game\n",fname);
 		nosignal=0;  return(-1);
 		}
 
@@ -200,7 +200,7 @@
 	cursors(); lprcat("\nRestoring . . .");  lflush();
 	if (lopen(fname) <= 0)
 		{
-		lcreat((char*)0); lprintf("\nCan't open file <%s>to restore game\n",fname);
+		lcreat((char*)0); lprintf(2,"\nCan't open file <%s>to restore game\n",fname);
 		nap(2000); c[GOLD]=c[BANKACCOUNT]=0;  died(-265); return;
 		}
 
