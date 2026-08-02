--- object.c.orig	2002-05-08 16:39:10.000000000 -0400
+++ object.c	2006-04-17 21:46:33.000000000 -0400
@@ -23,11 +23,11 @@
 
 	case OPOTION:	lprcat("\n\nYou have found a magic potion");
 				i = iarg[playerx][playery];
-				if (potionname[i][0]) lprintf(" of %s",&potionname[i][1]);  opotion(i);  break;
+				if (potionname[i][0]) lprintf(2," of %s",&potionname[i][1]);  opotion(i);  break;
 
 	case OSCROLL:	lprcat("\n\nYou have found a magic scroll");
 				i = iarg[playerx][playery];
-				if (scrollname[i][0])	lprintf(" of %s",&scrollname[i][1]);
+				if (scrollname[i][0])	lprintf(2," of %s",&scrollname[i][1]);
 				oscroll(i);  break;
 
 	case OALTAR:	if (nearbymonst()) return;
@@ -38,12 +38,12 @@
 	case OCOOKIE:	lprcat("\n\nYou have found a fortune cookie."); ocookie(); break;
 
 	case OTHRONE:	if (nearbymonst()) return;
-					lprintf("\n\nThere is %s here!",objectname[i]); othrone(0); break;
+					lprintf(2,"\n\nThere is %s here!",objectname[i]); othrone(0); break;
 
 	case OTHRONE2:	if (nearbymonst()) return;
-					lprintf("\n\nThere is %s here!",objectname[i]); othrone(1); break;
+					lprintf(2,"\n\nThere is %s here!",objectname[i]); othrone(1); break;
 
-	case ODEADTHRONE: lprintf("\n\nThere is %s here!",objectname[i]); odeadthrone(); break;
+	case ODEADTHRONE: lprintf(2,"\n\nThere is %s here!",objectname[i]); odeadthrone(); break;
 
 	case OORB:		lprcat("\n\nYou have found the Orb!!!!!"); oorb(); break;
 
@@ -109,7 +109,7 @@
 				oelevator(-1);	/*	down	*/
 				break;
 
-	case OOPENDOOR:		lprintf("\n\nYou have found %s",objectname[i]);
+	case OOPENDOOR:		lprintf(2,"\n\nYou have found %s",objectname[i]);
 						lprcat("\nDo you (c) close it"); iopts();
 						i=0; while ((i!='c') && (i!='i') && (i!='\33')) i=getchar();
 						if ((i=='\33') || (i=='i')) { ignore();  break; }
@@ -119,7 +119,7 @@
 						playerx = lastpx;  playery = lastpy;
 						break;
 
-	case OCLOSEDDOOR:	lprintf("\n\nYou have found %s",objectname[i]);
+	case OCLOSEDDOOR:	lprintf(2,"\n\nYou have found %s",objectname[i]);
 						lprcat("\nDo you (o) try to open it"); iopts();
 						i=0; while ((i!='o') && (i!='i') && (i!='\33')) i=getchar();
 						if ((i=='\33') || (i=='i'))
@@ -259,7 +259,7 @@
 	int itm;
 	{
 	int tmp,i;
-	lprintf("\n\nYou have found %s ",objectname[itm]);
+	lprintf(2,"\n\nYou have found %s ",objectname[itm]);
 	tmp=iarg[playerx][playery];
 	switch(itm)
 		{
@@ -268,7 +268,7 @@
 		case OCUBEofUNDEAD:	case ONOTHEFT:	break;
 
 		default:
-		if (tmp>0) lprintf("+ %d",(long)tmp); else if (tmp<0) lprintf(" %d",(long)tmp);
+		if (tmp>0) lprintf(2,"+ %d",(long)tmp); else if (tmp<0) lprintf(2," %d",(long)tmp);
 		}
 	lprcat("\nDo you want to (t) take it"); iopts();
 	i=0; while (i!='t' && i!='i' && i!='\33') i=getchar();
@@ -305,7 +305,7 @@
 					else
 						{
 						k=rnd((level+1)<<1);
-						lprintf("\nYou hurt your foot dumb dumb!  You suffer %d hit points",(long)k);
+						lprintf(2,"\nYou hurt your foot dumb dumb!  You suffer %d hit points",(long)k);
 						lastnum=276;  losehp(k);  bottomline();
 						}
 					return;
@@ -533,7 +533,7 @@
 /*
  *	function to adjust time when time warping and taking courses in school
  */
-adjtime(tim)
+larn_adjtime(tim)
 	long tim;
 	{
 	int j;
@@ -573,9 +573,9 @@
 	  case 6:	c[AGGRAVATE]+=800; return; /* aggravate monsters */
 
 	  case 7:	gtime += (i = rnd(1000) - 850); /* time warp */
-				if (i>=0) lprintf("\nYou went forward in time by %d mobuls",(long)((i+99)/100));
-				else lprintf("\nYou went backward in time by %d mobuls",(long)(-(i+99)/100));
-				adjtime((long)i);	/* adjust time for time warping */
+				if (i>=0) lprintf(2,"\nYou went forward in time by %d mobuls",(long)((i+99)/100));
+				else lprintf(2,"\nYou went backward in time by %d mobuls",(long)(-(i+99)/100));
+				larn_adjtime((long)i);	/* adjust time for time warping */
 				return;
 
 	  case 8:	oteleport(0);	  return;	/*	teleportation */
@@ -653,7 +653,7 @@
 			else
 				{
 				i = rnd(level*3+3);
-				lprintf("\nYou fell into a pit!  You suffer %d hit points damage",(long)i);
+				lprintf(2,"\nYou fell into a pit!  You suffer %d hit points damage",(long)i);
 				lastnum=261; 	/*	if he dies scoreboard will say so */
 				}
 			losehp(i); nap(2000);  newcavelevel(level+1);  draws(0,MAXX,0,MAXY);
@@ -710,7 +710,7 @@
 	if (lev<=3) i = rund((tmp=splev[lev])?tmp:1); else
 		i = rnd((tmp=splev[lev]-9)?tmp:1) + 9;
 	spelknow[i]=1;
-	lprintf("\nSpell \"%s\":  %s\n%s",spelcode[i],spelname[i],speldescript[i]);
+	lprintf(4,"\nSpell \"%s\":  %s\n%s",spelcode[i],spelname[i],speldescript[i]);
 	if (rnd(10)==4)
 	 { lprcat("\nYour int went up by one!"); c[INTELLIGENCE]++; bottomline(); }
 	}
@@ -746,7 +746,7 @@
 	if (arg==OMAXGOLD) i *= 100;
 		else if (arg==OKGOLD) i *= 1000;
 			else if (arg==ODGOLD) i *= 10;
-	lprintf("\nIt is worth %d!",(long)i);	c[GOLD] += i;  bottomgold();
+	lprintf(2,"\nIt is worth %d!",(long)i);	c[GOLD] += i;  bottomgold();
 	item[playerx][playery] = know[playerx][playery] = 0; /*	destroy gold	*/
 	}
 
@@ -778,7 +778,7 @@
 
 	while (1)
 		{
-		clear(); lprintf("Welcome home %s.  Latest word from the doctor is not good.\n",logname);
+		clear(); lprintf(2,"Welcome home %s.  Latest word from the doctor is not good.\n",logname);
 
 		if (gtime>TIMELIMIT)
 			{
@@ -788,8 +788,8 @@
 			}
 
 		lprcat("\nThe diagnosis is confirmed as dianthroritis.  He guesses that\n");
-		lprintf("your daughter has only %d mobuls left in this world.  It's up to you,\n",(long)((TIMELIMIT-gtime+99)/100));
-		lprintf("%s, to find the only hope for your daughter, the very rare\n",logname);
+		lprintf(2,"your daughter has only %d mobuls left in this world.  It's up to you,\n",(long)((TIMELIMIT-gtime+99)/100));
+		lprintf(2,"%s, to find the only hope for your daughter, the very rare\n",logname);
 		lprcat("potion of cure dianthroritis.  It is rumored that only deep in the\n");
 		lprcat("depths of the caves can this potion be found.\n\n\n");
 		lprcat("\n     ----- press "); standout("return");
