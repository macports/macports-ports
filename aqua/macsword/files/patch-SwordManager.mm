--- Backend/SwordManager.mm.orig	Mon Mar  7 12:36:42 2005
+++ Backend/SwordManager.mm	Mon Mar  7 13:23:15 2005
@@ -133,7 +133,7 @@
 			sword::LocaleMgr	*lManager;
 			sword::SWLocale		*myLocale;
 			
-			lManager = sword::LocaleMgr::getSystemLocaleMgr();
+			//lManager = sword::LocaleMgr::getSystemLocaleMgr();
 			
 			//get the language
 			fullNames = [NSDictionary dictionaryWithObjectsAndKeys:@"en", @"English", @"de", @"German", @"fr", @"French", @"nl", @"Dutch", @"it", @"Italian", @"ja", @"Japanese", @"es", @"Spanish", NULL];
@@ -182,7 +182,7 @@
 					{
 						myLocale = new sword::SWLocale(toUTF8(filePath));
 						
-						lManager->addLocale(myLocale);
+						//lManager->addLocale(myLocale);
 						lManager->setDefaultLocaleName(toLatin1(language));
 						break;
 					}
@@ -193,7 +193,7 @@
 					{
 						myLocale = new sword::SWLocale(toUTF8(filePath));
 						
-						lManager->addLocale(myLocale);
+						//lManager->addLocale(myLocale);
 						lManager->setDefaultLocaleName(toLatin1(language));
 						break;
 					}
