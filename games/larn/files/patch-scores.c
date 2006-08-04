--- scores.c.orig	2002-05-08 16:39:10.000000000 -0400
+++ scores.c	2006-04-17 21:48:47.000000000 -0400
@@ -210,7 +210,7 @@
 				if (p->score)
 					{
 					count++;
-					lprintf("%10d     %2d      %5d Mobuls   %s \n",
+					lprintf(5,"%10d     %2d      %5d Mobuls   %s \n",
 					(long)p->score,(long)p->hardlev,(long)p->timeused,p->who);
 					}
 				break;
@@ -245,11 +245,11 @@
 				if (sco[j].score)
 					{
 					count++;
-					lprintf("%10d     %2d       %s ",
+					lprintf(4,"%10d     %2d       %s ",
 						(long)sco[j].score,(long)sco[j].hardlev,sco[j].who);
-					if (sco[j].what < 256) lprintf("killed by a %s",monster[sco[j].what].name);
-						else lprintf("%s",whydead[sco[j].what - 256]);
-					if (x != 263) lprintf(" on %s",levelname[sco[j].level]);
+					if (sco[j].what < 256) lprintf(2,"killed by a %s",monster[sco[j].what].name);
+						else lprintf(2,"%s",whydead[sco[j].what - 256]);
+					if (x != 263) lprintf(2," on %s",levelname[sco[j].level]);
 					if (x)
 						{
 						for (n=0; n<26; n++) { iven[n]=sco[j].sciv[n][0]; ivenarg[n]=sco[j].sciv[n][1]; }
@@ -556,16 +556,16 @@
 int x;
 	{
 	char ch,*mod;
-	lprintf("Score: %d, Diff: %d,  %s ",(long)c[GOLD],(long)c[HARDGAME],logname);
+	lprintf(4,"Score: %d, Diff: %d,  %s ",(long)c[GOLD],(long)c[HARDGAME],logname);
 	if (x < 256)
 		{
 		ch = *monster[x].name;
 		if (ch=='a' || ch=='e' || ch=='i' || ch=='o' || ch=='u')
 			mod="an";  else mod="a";
-		lprintf("killed by %s %s",mod,monster[x].name);
+		lprintf(2,"killed by %s %s",mod,monster[x].name);
 		}
-	else lprintf("%s",whydead[x - 256]);
-	if (x != 263) lprintf(" on %s\n",levelname[level]);  else lprc('\n');
+	else lprintf(2,"%s",whydead[x - 256]);
+	if (x != 263) lprintf(2," on %s\n",levelname[level]);  else lprc('\n');
 	}
 
 /*
@@ -579,25 +579,25 @@
 	lcreat((char*)0);
 	if (lopen(logfile)<0)
 		{
-		lprintf("Can't locate log file <%s>\n",logfile);
+		lprintf(2,"Can't locate log file <%s>\n",logfile);
 		return;
 		}
 	if (fstat(fd,&stbuf) < 0)
 		{
-		lprintf("Can't  stat log file <%s>\n",logfile);
+		lprintf(2,"Can't  stat log file <%s>\n",logfile);
 		return;
 		}
 	for (n=stbuf.st_size/sizeof(struct log_fmt); n>0; --n)
 		{
 		lrfill((char*)&logg,sizeof(struct log_fmt));
 		p = ctime(&logg.diedtime); p[16]='\n'; p[17]=0;
-		lprintf("Score: %d, Diff: %d,  %s %s on %d at %s",(long)(logg.score),(long)(logg.diff),logg.who,logg.what,(long)(logg.cavelev),p+4);
+		lprintf(7,"Score: %d, Diff: %d,  %s %s on %d at %s",(long)(logg.score),(long)(logg.diff),logg.who,logg.what,(long)(logg.cavelev),p+4);
 #ifdef EXTRA
 		if (logg.moves<=0) logg.moves=1;
-		lprintf("  Experience Level: %d,  AC: %d,  HP: %d/%d,  Elapsed Time: %d minutes\n",(long)(logg.lev),(long)(logg.ac),(long)(logg.hp),(long)(logg.hpmax),(long)(logg.elapsedtime));
-		lprintf("  CPU time used: %d seconds,  Machine usage: %d.%02d%%\n",(long)(logg.cputime),(long)(logg.usage/100),(long)(logg.usage%100));
-		lprintf("  BYTES in: %d, out: %d, moves: %d, deaths: %d, spells cast: %d\n",(long)(logg.bytin),(long)(logg.bytout),(long)(logg.moves),(long)(logg.killed),(long)(logg.spused));
-		lprintf("  out bytes per move: %d,  time per move: %d ms\n",(long)(logg.bytout/logg.moves),(long)((logg.cputime*1000)/logg.moves));
+		lprintf(6,"  Experience Level: %d,  AC: %d,  HP: %d/%d,  Elapsed Time: %d minutes\n",(long)(logg.lev),(long)(logg.ac),(long)(logg.hp),(long)(logg.hpmax),(long)(logg.elapsedtime));
+		lprintf(4,"  CPU time used: %d seconds,  Machine usage: %d.%02d%%\n",(long)(logg.cputime),(long)(logg.usage/100),(long)(logg.usage%100));
+		lprintf(6,"  BYTES in: %d, out: %d, moves: %d, deaths: %d, spells cast: %d\n",(long)(logg.bytin),(long)(logg.bytout),(long)(logg.moves),(long)(logg.killed),(long)(logg.spused));
+		lprintf(3,"  out bytes per move: %d,  time per move: %d ms\n",(long)(logg.bytout/logg.moves),(long)((logg.cputime*1000)/logg.moves));
 #endif
 		}
 		lflush();  lrclose();  return;
@@ -645,7 +645,7 @@
 	/* if we get here, we didn't find him in the file -- put him there */
 addone:
 	if (lappend(playerids) < 0) return(-1);	/* can't open file for append */
-	lprintf("%d\n%s",(long)++high,name);  /* new id # and name */
+	lprintf(3,"%d\n%s",(long)++high,name);  /* new id # and name */
 	lwclose();
 	lcreat((char*)0);	/* re-open terminal channel */
 	return(high);
