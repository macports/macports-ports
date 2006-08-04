--- monster.c.orig	1999-11-16 06:47:40.000000000 -0500
+++ monster.c	2006-04-17 21:44:39.000000000 -0400
@@ -119,7 +119,7 @@
 	int x,y,k,i;
 	if (mon<1 || mon>MAXMONST+8)	/* check for monster number out of bounds */
 		{
-		beep(); lprintf("\ncan't createmonst(%d)\n",(long)mon); nap(3000); return;
+		beep(); lprintf(2,"\ncan't createmonst(%d)\n",(long)mon); nap(3000); return;
 		}
 	while (monster[mon].genocided && mon<MAXMONST) mon++; /* genocided? */
 	for (k=rnd(8), i= -8; i<0; i++,k++)	/* choose direction, then try all */
@@ -446,11 +446,11 @@
 					free((char*)save);	 positionplayer();  return;
 					}
 
-		case 37:	/* permanence */ adjtime(-99999L);  spelknow[37]=0; /* forget */
+		case 37:	/* permanence */ larn_adjtime(-99999L);  spelknow[37]=0; /* forget */
 					loseint();
 					return;
 
-		default:	lprintf("  spell %d not available!",(long)x); beep();  return;
+		default:	lprintf(2,"  spell %d not available!",(long)x); beep();  return;
 		};
 	}
 
@@ -490,7 +490,7 @@
 	int tmp;
 	if (x>=SPNUM || monst>=MAXMONST+8 || monst<0 || x<0) return(0);	/* bad spell or monst */
 	if ((tmp=spelweird[monst-1][x])==0) return(0);
-	cursors();  lprc('\n');  lprintf(spelmes[tmp],monster[monst].name);  return(1);
+	cursors();  lprc('\n');  lprintf(2,spelmes[tmp],monster[monst].name);  return(1);
 	}
 
 /*
@@ -548,7 +548,7 @@
 		else
 			{
 			lastnum=278;
-			lprintf(str,"spell caster (thats you)",(long)arg);
+			lprintf(3,str,"spell caster (thats you)",(long)arg);
 			beep(); losehp(dam); return;
 			}
 		}
@@ -556,7 +556,7 @@
 		{	lprcat("  There wasn't anything there!");	return;  }
 	ifblind(x,y);
 	if (nospell(spnum,m)) { lasthx=x;  lasthy=y; return; }
-	lprintf(str,lastmonst,(long)arg);       hitm(x,y,dam);
+	lprintf(3,str,lastmonst,(long)arg);       hitm(x,y,dam);
 	}
 
 /*
@@ -603,12 +603,12 @@
 			ifblind(x,y);
 			if (nospell(spnum,m)) { lasthx=x;  lasthy=y; return; }
 			cursors(); lprc('\n');
-			lprintf(str,lastmonst);		dam -= hitm(x,y,dam);
+			lprintf(2,str,lastmonst);		dam -= hitm(x,y,dam);
 			show1cell(x,y);  nap(1000);		x -= dx;	y -= dy;
 			}
 		else switch (*(p= &item[x][y]))
 			{
-			case OWALL:	cursors(); lprc('\n'); lprintf(str,"wall");
+			case OWALL:	cursors(); lprc('\n'); lprintf(2,str,"wall");
 						if (dam>=50+c[HARDGAME]) /* enough damage? */
 						 if (level<MAXLEVEL+MAXVLEVEL-1) /* not on V3 */
 						  if ((x<MAXX-1) && (y<MAXY-1) && (x) && (y))
@@ -620,7 +620,7 @@
 							}
 				god2:	dam = 0;	break;
 
-			case OCLOSEDDOOR:	cursors(); lprc('\n'); lprintf(str,"door");
+			case OCLOSEDDOOR:	cursors(); lprc('\n'); lprintf(2,str,"door");
 						if (dam>=40)
 							{
 							lprcat("  The door is blasted apart");
@@ -628,7 +628,7 @@
 							}
 						goto god2;
 
-			case OSTATUE:	cursors(); lprc('\n'); lprintf(str,"statue");
+			case OSTATUE:	cursors(); lprc('\n'); lprintf(2,str,"statue");
 						if (c[HARDGAME]<3)
 						  if (dam>44)
 							{
@@ -638,7 +638,7 @@
 							}
 						goto god2;
 
-			case OTHRONE:	cursors(); lprc('\n'); lprintf(str,"throne");
+			case OTHRONE:	cursors(); lprc('\n'); lprintf(2,str,"throne");
 					if (dam>39)
 						{
 						mitem[x][y]=GNOMEKING; hitp[x][y]=monster[GNOMEKING].hitpoints;
@@ -718,7 +718,7 @@
 				if (nospell(spnum,m) == 0)
 					{
 					ifblind(x,y);
-					cursors(); lprc('\n'); lprintf(str,lastmonst);
+					cursors(); lprc('\n'); lprintf(2,str,lastmonst);
 					hitm(x,y,dam);  nap(800);
 					}
 				else  { lasthx=x;  lasthy=y; }
@@ -836,7 +836,7 @@
 		if (c[WIELD]>0)
 		  if (ivenarg[c[WIELD]] > -10)
 			{
-			lprintf("\nYour weapon is dulled by the %s",lastmonst); beep();
+			lprintf(2,"\nYour weapon is dulled by the %s",lastmonst); beep();
 			--ivenarg[c[WIELD]];
 			}
 	if (flag)  hitm(x,y,damag);
@@ -879,7 +879,7 @@
 #ifdef EXTRA
 		c[MONSTKILLED]++;
 #endif
-		lprintf("\nThe %s died!",lastmonst);
+		lprintf(2,"\nThe %s died!",lastmonst);
 		raiseexperience((long)monster[monst].experience);
 		amt = monster[monst].gold;  if (amt>0) dropgold(rnd(amt)+amt);
 		dropsomething(monst);	disappear(x,y);	bottomline();
@@ -915,11 +915,11 @@
 	cursors();	ifblind(x,y);
 	if (c[INVISIBILITY]) if (rnd(33)<20)
 		{
-		lprintf("\nThe %s misses wildly",lastmonst);	return;
+		lprintf(2,"\nThe %s misses wildly",lastmonst);	return;
 		}
 	if (c[CHARMCOUNT]) if (rnd(30)+5*monster[mster].level-c[CHARISMA]<30)
 		{
-		lprintf("\nThe %s is awestruck at your magnificence!",lastmonst);
+		lprintf(2,"\nThe %s is awestruck at your magnificence!",lastmonst);
 		return;
 		}
 	if (mster==BAT) dam=1;
@@ -935,11 +935,11 @@
 		  tmp = 1;  bias -= 2; cursors(); }
 	if (((dam + bias) > c[AC]) || (rnd((int)((c[AC]>0)?c[AC]:1))==1))
 		{
-		lprintf("\n  The %s hit you ",lastmonst);	tmp = 1;
+		lprintf(2,"\n  The %s hit you ",lastmonst);	tmp = 1;
 		if ((dam -= c[AC]) < 0) dam=0;
 		if (dam > 0) { losehp(dam); bottomhp(); flushall(); }
 		}
-	if (tmp == 0)  lprintf("\n  The %s missed ",lastmonst);
+	if (tmp == 0)  lprintf(2,"\n  The %s missed ",lastmonst);
 	}
 
 /*
@@ -1118,7 +1118,7 @@
 					if (c[FIRERESISTANCE])
 					  p="\nThe %s's flame doesn't phase you!";
 					else
-			spout2: if (p) { lprintf(p,lastmonst); beep(); }
+			spout2: if (p) { lprintf(2,p,lastmonst); beep(); }
 					checkloss(i);
 					return(0);
 
@@ -1135,7 +1135,7 @@
 		case 5:		p="\nThe %s blasts you with his cold breath";
 					i = rnd(15)+18-c[AC];  goto spout2;
 
-		case 6:		lprintf("\nThe %s drains you of your life energy!",lastmonst);
+		case 6:		lprintf(2,"\nThe %s drains you of your life energy!",lastmonst);
 					loselevel();  beep();  return(0);
 
 		case 7:		p="\nThe %s got you with a gusher!";
@@ -1150,7 +1150,7 @@
 						if (c[GOLD] < 0) c[GOLD]=0;
 						}
 					else  p="\nThe %s couldn't find any gold to steal";
-					lprintf(p,lastmonst); disappear(xx,yy); beep();
+					lprintf(2,p,lastmonst); disappear(xx,yy); beep();
 					bottomgold();  return(1);
 
 		case 9:	for(j=50; ; )	/* disenchant */
@@ -1159,7 +1159,7 @@
 					if (m>0 && ivenarg[i]>0 && m!=OSCROLL && m!=OPOTION)
 						{
 						if ((ivenarg[i] -= 3)<0) ivenarg[i]=0;
-						lprintf("\nThe %s hits you -- you feel a sense of loss",lastmonst);
+						lprintf(2,"\nThe %s hits you -- you feel a sense of loss",lastmonst);
 						srcount=0; beep(); show3(i);  bottomline();  return(0);
 						}
 					if (--j<=0)
@@ -1188,7 +1188,7 @@
 					  p="\nThe %s couldn't find anything to steal";
 					  break;
 					  }
-					lprintf("\nThe %s picks your pocket and takes:",lastmonst);
+					lprintf(2,"\nThe %s picks your pocket and takes:",lastmonst);
 					beep();
 					if (stealsomething()==0) lprcat("  nothing"); disappear(xx,yy);
 					bottomline();  return(1);
@@ -1199,7 +1199,7 @@
 
 		case 16:	i= rnd(15)+10-c[AC];  goto spout3;
 		};
-	if (p) { lprintf(p,lastmonst); bottomline(); }
+	if (p) { lprintf(2,p,lastmonst); bottomline(); }
 	return(0);
 	}
 
@@ -1239,7 +1239,7 @@
 					}
 				else
 					{
-					lprintf("\nThe %s barely escapes being annihilated!",monster[*p].name);
+					lprintf(2,"\nThe %s barely escapes being annihilated!",monster[*p].name);
 					hitp[i][j] = (hitp[i][j]>>1) + 1; /* lose half hit points*/
 					}
 			}
@@ -1276,13 +1276,13 @@
 	if ((m=mitem[x][y]) >= DEMONLORD+4)	/* demons dispel spheres */
 		{
 		know[x][y]=1; show1cell(x,y);	/* show the demon (ha ha) */
-		cursors(); lprintf("\nThe %s dispels the sphere!",monster[m].name);
+		cursors(); lprintf(2,"\nThe %s dispels the sphere!",monster[m].name);
 		beep(); rmsphere(x,y);	/* remove any spheres that are here */
 		return(c[SPHCAST]);
 		}
 	if (m==DISENCHANTRESS) /* disenchantress cancels spheres */
 		{
-		cursors(); lprintf("\nThe %s causes cancellation of the sphere!",monster[m].name); beep();
+		cursors(); lprintf(2,"\nThe %s causes cancellation of the sphere!",monster[m].name); beep();
 boom:	sphboom(x,y);	/* blow up stuff around sphere */
 		rmsphere(x,y);	/* remove any spheres that are here */
 		return(c[SPHCAST]);
@@ -1384,7 +1384,7 @@
 		if (monstnamelist[j]==i)	/* have we found it? */
 			{
 			monster[j].genocided=1;	/* genocided from game */
-			lprintf("  There will be no more %s's",monster[j].name);
+			lprintf(2,"  There will be no more %s's",monster[j].name);
 			/* now wipe out monsters on this level */
 			newcavelevel(level); draws(0,MAXX,0,MAXY); bot_linex();
 			return;
