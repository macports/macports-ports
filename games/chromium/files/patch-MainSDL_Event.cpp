--- src/MainSDL_Event.cpp	Mon May 21 03:36:48 2001
+++ ../../MainSDL_Event.cpp	Fri Nov  5 14:06:23 2004
@@ -325,10 +325,10 @@
 			game->hero->moveEvent( 10, 0);
 			break;
 	    case SDLK_UP:
-			game->hero->moveEvent(0, -10);
+			game->hero->moveEvent(0, 10);
 			break;
 	    case SDLK_DOWN:
-			game->hero->moveEvent(0,  10);
+			game->hero->moveEvent(0, -10);
 			break;
 //	    case SDLK_SPACE:
 //			game->hero->fireGun(true);
