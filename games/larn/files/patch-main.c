--- main.c.orig	2002-05-08 16:39:10.000000000 -0400
+++ main.c	2006-04-17 21:43:17.000000000 -0400
@@ -246,13 +246,13 @@
 	{
 	int i,j,k,sigsav;
 	srcount=0;  sigsav=nosignal;  nosignal=1; /* don't allow ^c etc */
-	if (c[GOLD]) { lprintf(".)   %d gold pieces",(long)c[GOLD]); srcount++; }
+	if (c[GOLD]) { lprintf(2,".)   %d gold pieces",(long)c[GOLD]); srcount++; }
 	for (k=26; k>=0; k--)
 	  if (iven[k])
 		{  for (i=22; i<84; i++)
 			 for (j=0; j<=k; j++)  if (i==iven[j])  show3(j); k=0; }
 
-	lprintf("\nElapsed time is %d.  You have %d mobuls left",(long)((gtime+99)/100+1),(long)((TIMELIMIT-gtime)/100));
+	lprintf(3,"\nElapsed time is %d.  You have %d mobuls left",(long)((gtime+99)/100+1),(long)((TIMELIMIT-gtime)/100));
 	more();		nosignal=sigsav;
 	}
 
@@ -438,9 +438,9 @@
 	int idx;
 	char *str2[];
 	{
-	if (str2==0)  lprintf("\n%c)   %s",idx+'a',objectname[iven[idx]]);
-	else if (*str2[ivenarg[idx]]==0)  lprintf("\n%c)   %s",idx+'a',objectname[iven[idx]]);
-	else lprintf("\n%c)   %s of%s",idx+'a',objectname[iven[idx]],str2[ivenarg[idx]]);
+	if (str2==0)  lprintf(3,"\n%c)   %s",idx+'a',objectname[iven[idx]]);
+	else if (*str2[ivenarg[idx]]==0)  lprintf(3,"\n%c)   %s",idx+'a',objectname[iven[idx]]);
+	else lprintf(4,"\n%c)   %s of%s",idx+'a',objectname[iven[idx]],str2[ivenarg[idx]]);
 	}
 
 show3(index)
@@ -456,9 +456,9 @@
 		case OEMERALD:		case OCHEST:		case OCOOKIE:
 		case OSAPPHIRE:		case ONOTHEFT:		show1(index,(char **)0);  break;
 
-		default:		lprintf("\n%c)   %s",index+'a',objectname[iven[index]]);
-						if (ivenarg[index]>0) lprintf(" + %d",(long)ivenarg[index]);
-						else if (ivenarg[index]<0) lprintf(" %d",(long)ivenarg[index]);
+		default:		lprintf(3,"\n%c)   %s",index+'a',objectname[iven[index]]);
+						if (ivenarg[index]>0) lprintf(2," + %d",(long)ivenarg[index]);
+						else if (ivenarg[index]<0) lprintf(2," %d",(long)ivenarg[index]);
 						break;
 		}
 	if (c[WIELD]==index) lprcat(" (weapon in hand)");
@@ -606,11 +606,11 @@
 						return;
 
 			case 'g':	cursors();
-						lprintf("\nThe stuff you are carrying presently weighs %d pounds",(long)packweight());
+						lprintf(2,"\nThe stuff you are carrying presently weighs %d pounds",(long)packweight());
 			case ' ':	yrepcount=0;	nomove=1;  return;
 
 			case 'v':	yrepcount=0;	cursors();
-						lprintf("\nCaverns of Larn, Version %d.%d, Diff=%d",(long)VERSION,(long)SUBVERSION,(long)c[HARDGAME]);
+						lprintf(4,"\nCaverns of Larn, Version %d.%d, Diff=%d",(long)VERSION,(long)SUBVERSION,(long)c[HARDGAME]);
 						if (wizard) lprcat(" Wizard"); nomove=1;
 						if (cheat) lprcat(" Cheater");
 						lprcat(copyright);
@@ -628,7 +628,7 @@
 #endif
 			case 'P':	cursors();
 						if (outstanding_taxes>0)
-							lprintf("\nYou presently owe %d gp in taxes.",(long)outstanding_taxes);
+							lprintf(2,"\nYou presently owe %d gp in taxes.",(long)outstanding_taxes);
 						else
 							lprcat("\nYou do not owe any taxes.");
 						return;
@@ -681,10 +681,10 @@
  */
 ydhi(x)
 	int x;
-	{ cursors();  lprintf("\nYou don't have item %c!",x); }
+	{ cursors();  lprintf(2,"\nYou don't have item %c!",x); }
 ycwi(x)
 	int x;
-	{ cursors();  lprintf("\nYou can't wield item %c!",x); }
+	{ cursors();  lprintf(2,"\nYou can't wield item %c!",x); }
 
 /*
 	function to wear armor
@@ -748,7 +748,7 @@
 				else
 					{ *p=OKGOLD; i=32767; amt = 32767000L; }
 				c[GOLD] -= amt;
-				lprintf("You drop %d gold pieces",(long)amt);
+				lprintf(2,"You drop %d gold pieces",(long)amt);
 				iarg[playerx][playery]=i; bottomgold();
 				know[playerx][playery]=0; dropflag=1;  return;
 				}
@@ -842,7 +842,7 @@
 	char *str;
 	{
 	int i;
-	cursors();  lprintf("\nWhat do you want to %s [* for all] ? ",str);
+	cursors();  lprintf(2,"\nWhat do you want to %s [* for all] ? ",str);
 	i=0; while (i>'z' || (i<'a' && i!='*' && i!='\33' && i!='.')) i=getchar();
 	if (i=='\33')  lprcat(" aborted");
 	return(i);
