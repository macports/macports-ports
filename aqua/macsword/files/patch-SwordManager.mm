--- ../../patch-devel/macsword.orig/Backend/SwordManager.mm	Thu May  6 04:46:54 2004
+++ Backend/SwordManager.mm	Sat May 22 21:00:10 2004
@@ -130,9 +130,6 @@
 			NSString			*language;
 			NSEnumerator		*langEnum;
 			NSDictionary		*fullNames;
-			sword::LocaleMgr	*lManager;
-			
-			lManager = sword::LocaleMgr::getSystemLocaleMgr();
 			
 			fullNames = [NSDictionary dictionaryWithObjectsAndKeys:@"en", @"English", @"de", @"German", @"fr", @"French", @"nl", @"Dutch", @"it", @"Italian", @"ja", @"Japanese", @"es", @"Spanish", NULL];
 			
@@ -140,7 +137,7 @@
 			
 			//NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]);
 			
-			lManager->loadConfigDir(toUTF8([[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"locales.d"]));
+			sword::LocaleMgr::systemLocaleMgr.loadConfigDir(toUTF8([[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"locales.d"]));
 			
 			while(language = [langEnum nextObject])
 			{
@@ -151,9 +148,9 @@
 				
 				if([language isEqualToString:@"en"])
 					break;
-				if(lManager->getLocale(toLatin1(language)))
+				if(sword::LocaleMgr::systemLocaleMgr.getLocale(toLatin1(language)))
 				{
-					lManager->setDefaultLocaleName(toLatin1(language));
+					sword::LocaleMgr::systemLocaleMgr.setDefaultLocaleName(toLatin1(language));
 					break;
 				}
 			}
