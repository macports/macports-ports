--- posix/posix.m.sav	Fri Aug  6 11:39:58 2004
+++ posix/posix.m	Fri Aug  6 11:40:17 2004
@@ -238,7 +238,7 @@
 		case EACCES:	En = 1;		break;
 		case EAGAIN:	En = 2;		break;
 		case EBADF:	En = 3;		break;
-		case EBADMSG:	En = 4;		break;
+		/* case EBADMSG:	En = 4;		break; */
 		case EBUSY:	En = 5;		break;
 		/* case ECANCELED:	En = 6;		break; */
 		case ECHILD:	En = 7;		break;
