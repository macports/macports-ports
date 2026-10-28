--- moreobj.c.orig	1999-11-15 21:57:22.000000000 -0500
+++ moreobj.c	2006-04-17 21:45:06.000000000 -0400
@@ -200,7 +200,7 @@
 						{
 						lprcat("\nThe chest explodes as you open it"); beep();
 						i = rnd(10);  lastnum=281;  /* in case he dies */
-						lprintf("\nYou suffer %d hit points damage!",(long)i);
+						lprintf(2,"\nYou suffer %d hit points damage!",(long)i);
 						checkloss(i);
 						switch(rnd(10))	/* see if he gets a curse */
 							{
@@ -284,7 +284,7 @@
 					if (rnd(100) < 11)
 						{
 						x=rnd((level<<2)+2);
-						lprintf("\nOh no!  The water was foul!  You suffer %d hit points!",(long)x);
+						lprintf(2,"\nOh no!  The water was foul!  You suffer %d hit points!",(long)x);
 						lastnum=273; losehp(x); bottomline();  cursors();
 						}
 					else
@@ -338,20 +338,20 @@
 		case 6:	lprcat("Your charm");			fch(how,&c[5]);		break;
 		case 7:	j=rnd(level+1);
 				if (how < 0)
-					{ lprintf("You lose %d hit point",(long)j);  if (j>1) lprcat("s!"); else lprc('!'); losemhp((int)j); }
+					{ lprintf(2,"You lose %d hit point",(long)j);  if (j>1) lprcat("s!"); else lprc('!'); losemhp((int)j); }
 				else
-					{ lprintf("You gain %d hit point",(long)j);  if (j>1) lprcat("s!"); else lprc('!'); raisemhp((int)j); }
+					{ lprintf(2,"You gain %d hit point",(long)j);  if (j>1) lprcat("s!"); else lprc('!'); raisemhp((int)j); }
 				bottomline();		break;
 
 		case 8:	j=rnd(level+1);
 				if (how > 0)
 					{
-					lprintf("You just gained %d spell",(long)j);  raisemspells((int)j);
+					lprintf(2,"You just gained %d spell",(long)j);  raisemspells((int)j);
 					if (j>1) lprcat("s!"); else lprc('!');
 					}
 				else
 					{
-					lprintf("You just lost %d spell",(long)j);	losemspells((int)j);
+					lprintf(2,"You just lost %d spell",(long)j);	losemspells((int)j);
 					if (j>1) lprcat("s!"); else lprc('!');
 					}
 				bottomline();		break;
@@ -359,12 +359,12 @@
 		case 9:	j = 5*rnd((level+1)*(level+1));
 				if (how < 0)
 					{
-					lprintf("You just lost %d experience point",(long)j);
+					lprintf(2,"You just lost %d experience point",(long)j);
 					if (j>1) lprcat("s!"); else lprc('!'); loseexperience((long)j);
 					}
 				else
 					{
-					lprintf("You just gained %d experience point",(long)j);
+					lprintf(2,"You just gained %d experience point",(long)j);
 					if (j>1) lprcat("s!"); else lprc('!'); raiseexperience((long)j);
 					}
 				break;
