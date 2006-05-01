--- src/pw/pwMacOSX.cxx.orig	2004-04-06 17:45:19.000000000 -0600
+++ src/pw/pwMacOSX.cxx	2006-04-30 19:43:22.000000000 -0600
@@ -311,10 +311,10 @@
 {
 	OSErr err;
 	long response;
-	MenuHandle menu = NewMenu(mApple, "\p\024");
+	MenuHandle menu = NewMenu(mApple, (const unsigned char*) "\p\024");
 	InsertMenu(menu, 0);
 
-	InsertMenuItem(menu, "\pAbout Plib...", 0);
+	InsertMenuItem(menu, (const unsigned char*) "\pAbout Plib...", 0);
 
 #if !TARGET_API_MAC_CARBON
 	AppendResMenu(menu, 'DRVR');
@@ -325,9 +325,9 @@
 
 	if (err != noErr || response < 0x00001000)
 	{
-		menu = NewMenu (mFile, "\pFile");			// new menu
+		menu = NewMenu (mFile, (const unsigned char*) "\pFile");			// new menu
 		InsertMenu (menu, 0);						// add menu to end
-		AppendMenu (menu, "\pQuit/Q"); 				// add items
+		AppendMenu (menu, (const unsigned char*) "\pQuit/Q"); 				// add items
 	}
 	
 	DrawMenuBar();
@@ -370,7 +370,7 @@
 	CtoPcpy( Pversion, version );
 	StandardAlert ( kAlertPlainAlert,
    					Pversion,
-   					"\pfor more infos see <http://plib.sourceforge.net>",
+   					(const unsigned char*) "\pfor more infos see <http://plib.sourceforge.net>",
    					NULL,
    					&outItemHit  );
 }
