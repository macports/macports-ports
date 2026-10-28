--- display.c.orig	1999-11-15 21:57:21.000000000 -0500
+++ display.c	2006-04-17 21:41:24.000000000 -0400
@@ -32,20 +32,20 @@
 	if (cbak[SPELLS] <= -50 || (always))
 		{
 		cursor( 1,18);
-		if (c[SPELLMAX]>99)  lprintf("Spells:%3d(%3d)",(long)c[SPELLS],(long)c[SPELLMAX]);
-						else lprintf("Spells:%3d(%2d) ",(long)c[SPELLS],(long)c[SPELLMAX]);
-		lprintf(" AC: %-3d  WC: %-3d  Level",(long)c[AC],(long)c[WCLASS]);
-		if (c[LEVEL]>99) lprintf("%3d",(long)c[LEVEL]);
-					else lprintf(" %-2d",(long)c[LEVEL]);
-		lprintf(" Exp: %-9d %s\n",(long)c[EXPERIENCE],class[c[LEVEL]-1]);
-		lprintf("HP: %3d(%3d) STR=%-2d INT=%-2d ",
+		if (c[SPELLMAX]>99)  lprintf(3,"Spells:%3d(%3d)",(long)c[SPELLS],(long)c[SPELLMAX]);
+						else lprintf(3,"Spells:%3d(%2d) ",(long)c[SPELLS],(long)c[SPELLMAX]);
+		lprintf(3," AC: %-3d  WC: %-3d  Level",(long)c[AC],(long)c[WCLASS]);
+		if (c[LEVEL]>99) lprintf(2,"%3d",(long)c[LEVEL]);
+					else lprintf(2," %-2d",(long)c[LEVEL]);
+		lprintf(3," Exp: %-9d %s\n",(long)c[EXPERIENCE],class[c[LEVEL]-1]);
+		lprintf(5,"HP: %3d(%3d) STR=%-2d INT=%-2d ",
 			(long)c[HP],(long)c[HPMAX],(long)(c[STRENGTH]+c[STREXTRA]),(long)c[INTELLIGENCE]);
-		lprintf("WIS=%-2d CON=%-2d DEX=%-2d CHA=%-2d LV:",
+		lprintf(5,"WIS=%-2d CON=%-2d DEX=%-2d CHA=%-2d LV:",
 			(long)c[WISDOM],(long)c[CONSTITUTION],(long)c[DEXTERITY],(long)c[CHARISMA]);
 
 		if ((level==0) || (wizard))  c[TELEFLAG]=0;
 		if (c[TELEFLAG])  lprcat(" ?");  else  lprcat(levelname[level]);
-		lprintf("  Gold: %-6d",(long)c[GOLD]);
+		lprintf(2,"  Gold: %-6d",(long)c[GOLD]);
 		always=1;  botside();
 		c[TMP] = c[STRENGTH]+c[STREXTRA];
 		for (i=0; i<100; i++) cbak[i]=c[i];
@@ -155,7 +155,7 @@
 	int x,y;
 	y = idx & 0xff;		x = (idx>>8) & 0xff;	  idx >>= 16;
 	if (c[idx] != cbak[idx])
-		{ cbak[idx]=c[idx];  cursor(x,y);  lprintf(str,(long)c[idx]); }
+		{ cbak[idx]=c[idx];  cursor(x,y);  lprintf(2,str,(long)c[idx]); }
 	}
 
 /*
@@ -393,7 +393,7 @@
 	lprcat("The magic spells you have discovered thus far:\n\n");
 	for (i=0; i<SPNUM; i++)
 		if (spelknow[i])
-			{ lprintf("%s %-20s ",spelcode[i],spelname[i]);  seepage(); }
+			{ lprintf(3,"%s %-20s ",spelcode[i],spelname[i]);  seepage(); }
 
 	if (arg== -1)
 		{
@@ -408,7 +408,7 @@
 	for (i=0; i<MAXSCROLL; i++)
 		if (scrollname[i][0])
 		  if (scrollname[i][1]!=' ')
-			{ lprintf("%-26s",&scrollname[i][1]);  seepage(); }
+			{ lprintf(2,"%-26s",&scrollname[i][1]);  seepage(); }
 
 	lincount += 3;  if (count!=0) { count=2;  seepage(); }
 
@@ -417,7 +417,7 @@
 	for (i=0; i<MAXPOTION; i++)
 		if (potionname[i][0])
 		  if (potionname[i][1]!=' ')
-			{ lprintf("%-26s",&potionname[i][1]);  seepage(); }
+			{ lprintf(2,"%-26s",&potionname[i][1]);  seepage(); }
 
 	if (lincount!=0) more();	nosignal=0;  setscroll();	drawscreen();
 	}
