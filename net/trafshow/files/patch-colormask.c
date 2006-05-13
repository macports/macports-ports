*** colormask.c~	2006-05-13 13:54:56.000000000 +0200
--- colormask.c	2006-05-13 13:54:56.000000000 +0200
***************
*** 381,387 ****
  		(void)strcat(buf, ".");
  		(void)strcat(buf, progname);
  		if ((fp = fopen(buf, "r")) == NULL) {
! 			(void)strcpy(buf, "/etc/");
  			(void)strcat(buf, progname);
  			if ((fp = fopen(buf, "r")) == NULL) return 0;
  		}
--- 381,387 ----
  		(void)strcat(buf, ".");
  		(void)strcat(buf, progname);
  		if ((fp = fopen(buf, "r")) == NULL) {
! 			(void)strcpy(buf, "%%PREFIX%%/etc/");
  			(void)strcat(buf, progname);
  			if ((fp = fopen(buf, "r")) == NULL) return 0;
  		}
