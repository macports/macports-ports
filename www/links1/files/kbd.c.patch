--- kbd.c.orig	2011-11-22 22:27:53 UTC
+++ kbd.c
@@ -582,10 +582,10 @@ int process_queue(struct itrm *itrm)
 				case 'B': ev.x = KBD_DOWN; break;
 				case 'C': ev.x = KBD_RIGHT; break;
 				case 'D': ev.x = KBD_LEFT; break;
-				case 'F':
+				case 'F': ev.x = KBD_END; break;
 				case 'K':
 				case 'e': ev.x = KBD_END; break;
-				case 'H':
+				case 'H': ev.x = KBD_HOME; break;
 				case 0: ev.x = KBD_HOME; break;
 				case 'V':
 				case 'I': ev.x = KBD_PAGE_UP; break;
