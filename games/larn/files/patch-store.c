--- store.c.orig	1999-11-29 22:49:00.000000000 -0500
+++ store.c	2006-04-17 21:50:03.000000000 -0400
@@ -213,7 +213,7 @@
   if (outstanding_taxes>0)
 	{
 	lprcat("\n\nThe Larn Revenue Service has ordered us to not do business with tax evaders.\n"); beep();
-	lprintf("They have also told us that you owe %d gp in back taxes, and as we must\n",(long)outstanding_taxes);
+	lprintf(2,"They have also told us that you owe %d gp in back taxes, and as we must\n",(long)outstanding_taxes);
 	lprcat("comply with the law, we cannot serve you at this time.  Soo Sorry.\n");
 	cursors();
 	lprcat("\nPress "); standout("escape"); lprcat(" to leave: "); lflush();
@@ -225,7 +225,7 @@
   dnd_hed();
   while (1)
 	{
-	cursor(59,18); lprintf("%d gold pieces",(long)c[GOLD]);
+	cursor(59,18); lprintf(2,"%d gold pieces",(long)c[GOLD]);
 	cltoeoln(); cl_dn(1,20);	/* erase to eod */
 	lprcat("\nEnter your transaction ["); standout("space");
 	lprcat(" for more, "); standout("escape");
@@ -271,14 +271,14 @@
 	int j,k;
 	if (i >= maxitm)  return;
 	cursor( (j=(i&1)*40+1) , (k=((i%26)>>1)+5) );
-	if (itm[i].qty == 0)  { lprintf("%39s","");  return; }
-	lprintf("%c) ",(i%26)+'a');
+	if (itm[i].qty == 0)  { lprintf(2,"%39s","");  return; }
+	lprintf(2,"%c) ",(i%26)+'a');
 	if (itm[i].obj == OPOTION)
-		{ lprcat("potion of "); lprintf("%s",&potionname[itm[i].arg][1]); }
+		{ lprcat("potion of "); lprintf(2,"%s",&potionname[itm[i].arg][1]); }
 	else if (itm[i].obj == OSCROLL)
-		{ lprcat("scroll of "); lprintf("%s",&scrollname[itm[i].arg][1]); }
-	else lprintf("%s",objectname[itm[i].obj]);
-	cursor( j+31,k );  lprintf("%6d",(long)(itm[i].price*10));
+		{ lprcat("scroll of "); lprintf(2,"%s",&scrollname[itm[i].arg][1]); }
+	else lprintf(2,"%s",objectname[itm[i].obj]);
+	cursor( j+31,k );  lprintf(2,"%6d",(long)(itm[i].price*10));
 	}
 
 
@@ -326,7 +326,7 @@
 	sch_hed();
 	while (1)
 		{
-		cursor(57,18); lprintf("%d gold pieces.   ",(long)c[GOLD]); cursors();
+		cursor(57,18); lprintf(2,"%d gold pieces.   ",(long)c[GOLD]); cursors();
 		lprcat("\nWhat is your choice ["); standout("escape");
 		lprcat(" to leave] ? ");  yrepcount=0;
 		i=0;  while ((i<'a' || i>'h') && (i!='\33') && (i!=12)) i=getchar();
@@ -396,7 +396,7 @@
 
 			  if (c[BLINDCOUNT])	c[BLINDCOUNT]=1;  /* cure blindness too!  */
 			  if (c[CONFUSE])		c[CONFUSE]=1;	/*	end confusion	*/
-			  adjtime((long)time_used);	/* adjust parameters for time change */
+			  larn_adjtime((long)time_used);	/* adjust parameters for time change */
 			  }
 			nap(1000);
 			}
@@ -427,7 +427,7 @@
 		{
 		int i;
 		lprcat("\n\nThe Larn Revenue Service has ordered that your account be frozen until all\n"); beep();
-		lprintf("levied taxes have been paid.  They have also told us that you owe %d gp in\n",(long)outstanding_taxes);
+		lprintf(2,"levied taxes have been paid.  They have also told us that you owe %d gp in\n",(long)outstanding_taxes);
 		lprcat("taxes, and we must comply with them. We cannot serve you at this time.  Sorry.\n");
 		lprcat("We suggest you go to the LRS office and pay your taxes.\n");
 		cursors();
@@ -480,12 +480,12 @@
 					else gemvalue[i] = (255&ivenarg[i])*100;
 					gemorder[i]=k;
 					cursor( (k%2)*40+1 , (k>>1)+4 );
-					lprintf("%c) %s",i+'a',objectname[iven[i]]);
+					lprintf(3,"%c) %s",i+'a',objectname[iven[i]]);
 					cursor( (k%2)*40+33 , (k>>1)+4 );
-					lprintf("%5d",(long)gemvalue[i]);  k++;
+					lprintf(2,"%5d",(long)gemvalue[i]);  k++;
 			};
-	cursor(31,17); lprintf("You have %8d gold pieces in the bank.",(long)c[BANKACCOUNT]);
-	cursor(40,18); lprintf("You have %8d gold pieces",(long)c[GOLD]);
+	cursor(31,17); lprintf(2,"You have %8d gold pieces in the bank.",(long)c[BANKACCOUNT]);
+	cursor(40,18); lprintf(2,"You have %8d gold pieces",(long)c[GOLD]);
 	if (c[BANKACCOUNT]+c[GOLD] >= 500000)
 		lprcat("\nNote:  Larndom law states that only deposits under 500,000gp  can earn interest.");
 	while (1)
@@ -522,26 +522,26 @@
 								c[GOLD]+=gemvalue[i];  iven[i]=0;
 								gemvalue[i]=0;	k = gemorder[i];
 								cursor( (k%2)*40+1 , (k>>1)+4 );
-								lprintf("%39s","");
+								lprintf(2,"%39s","");
 								}
 							}
 						else
 							{
 							if (gemvalue[i=i-'a']==0)
 								{
-								lprintf("\nItem %c is not a gemstone!",i+'a');
+								lprintf(2,"\nItem %c is not a gemstone!",i+'a');
 								nap(2000); break;
 								}
 							c[GOLD]+=gemvalue[i];  iven[i]=0;
 							gemvalue[i]=0;	k = gemorder[i];
-							cursor( (k%2)*40+1 , (k>>1)+4 ); lprintf("%39s","");
+							cursor( (k%2)*40+1 , (k>>1)+4 ); lprintf(2,"%39s","");
 							}
 						break;
 
 			case '\33':	return;
 			};
-		cursor(40,17); lprintf("%8d",(long)c[BANKACCOUNT]);
-		cursor(49,18); lprintf("%8d",(long)c[GOLD]);
+		cursor(40,17); lprintf(2,"%8d",(long)c[BANKACCOUNT]);
+		cursor(49,18); lprintf(2,"%8d",(long)c[GOLD]);
 		}
 	}
 
@@ -555,7 +555,7 @@
 	for (j=0; j<26; j++)
 	  if (iven[j]==gemstone)
 		{
-		lprintf("\nI see you have %s",objectname[gemstone]);
+		lprintf(2,"\nI see you have %s",objectname[gemstone]);
 		if (gemstone==OLARNEYE) lprcat("  I must commend you.  I didn't think\nyou could get it.");
 		lprcat("  Shall I appraise it for you? ");  yrepcount=0;
 		if (getyn()=='y')
@@ -567,7 +567,7 @@
 				if (amt<50000) amt=50000;
 				}
 			else amt = (255 & ivenarg[j]) * 100;
-			lprintf("\nI can see this is an excellent stone, It is worth %d",(long)amt);
+			lprintf(2,"\nI can see this is an excellent stone, It is worth %d",(long)amt);
 			lprcat("\nWould you like to sell it to us? ");  yrepcount=0;
 			if (getyn()=='y') { lprcat("yes\n"); c[GOLD]+=amt;  iven[j]=0; }
 			else lprcat("no thank you.\n");
@@ -609,7 +609,7 @@
 		{ j=1; cnsitm(); }	/* can't sell unidentified item */
 	if (!j)
 	  if (i=='*') { clear(); qshowstr(); otradhead(); }
-	else  if (iven[isub]==0)  lprintf("\nYou don't have item %c!",isub+'a');
+	else  if (iven[isub]==0)  lprintf(2,"\nYou don't have item %c!",isub+'a');
 	else
 		{
 		for (j=0; j<maxitm; j++)
@@ -627,7 +627,7 @@
 				if (izarg >= 0) value *= 2;
 				while ((izarg-- > 0) && ((value=14*(67+value)/10) < 500000));
 				}
-			lprintf("\nItem (%c) is worth %d gold pieces to us.  Do you want to sell it? ",i,(long)value);
+			lprintf(3,"\nItem (%c) is worth %d gold pieces to us.  Do you want to sell it? ",i,(long)value);
 			yrepcount=0;
 			if (getyn()=='y')
 				{
@@ -683,12 +683,12 @@
 
 nxt:	cursor(1,6);
 		if (outstanding_taxes>0)
-			lprintf("You presently owe %d gp in taxes.  ",(long)outstanding_taxes);
+			lprintf(2,"You presently owe %d gp in taxes.  ",(long)outstanding_taxes);
 		else
 			lprcat("You do not owe us any taxes.           ");
 		cursor(1,8);
 		if (c[GOLD]>0)
-			lprintf("You have %6d gp.    ",(long)c[GOLD]);
+			lprintf(2,"You have %6d gp.    ",(long)c[GOLD]);
 		else
 			lprcat("You have no gold pieces.  ");
 		}
