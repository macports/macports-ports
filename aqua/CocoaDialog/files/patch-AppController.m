--- src/AppController.m.orig	2006-02-26 00:12:44.000000000 +0000
+++ src/AppController.m	2009-12-28 11:07:40.000000000 +0000
@@ -111,41 +111,41 @@
 	[NSApp terminate:self];
 }
 
-- (CDControl *) chooseControl:(NSString *)runMode useOptions:options addExtraOptionsTo:(NSMutableDictionary *)extraOptions
+- (CDControl *) chooseControl:(NSString *)runMode useOptions:(CDOptions *)options addExtraOptionsTo:(NSMutableDictionary *)extraOptions
 {
 	if (runMode == nil || [runMode isEqualToString:@"--help"]) {
 		[CDControl printHelp];
 		return nil;
 	} else if ([runMode isEqualToString:@"fileselect"]) {
-		return [[[CDFileSelectControl alloc] initWithOptions:options] autorelease];
+		return [[[CDFileSelectControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"filesave"]) {
-		return [[[CDFileSaveControl alloc] initWithOptions:options] autorelease];
+		return [[[CDFileSaveControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"msgbox"]) {
-		return [[[CDMsgboxControl alloc] initWithOptions:options] autorelease];
+		return [[[CDMsgboxControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"yesno-msgbox"]) {
-		return [[[CDYesNoMsgboxControl alloc] initWithOptions:options] autorelease];
+		return [[[CDYesNoMsgboxControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"ok-msgbox"]) {
-		return [[[CDOkMsgboxControl alloc] initWithOptions:options] autorelease];
+		return [[[CDOkMsgboxControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"textbox"]) {
-		return [[[CDTextboxControl alloc] initWithOptions:options] autorelease];
+		return [[[CDTextboxControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"progressbar"]) {
-		return [[[CDProgressbarControl alloc] initWithOptions:options] autorelease];
+		return [[[CDProgressbarControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"inputbox"]) {
-		return [[[CDInputboxControl alloc] initWithOptions:options] autorelease];
+		return [[[CDInputboxControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"standard-inputbox"]) {
-		return [[[CDStandardInputboxControl alloc] initWithOptions:options] autorelease];
+		return [[[CDStandardInputboxControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"secure-standard-inputbox"]) {
 		[extraOptions setObject:[NSNumber numberWithBool:NO] forKey:@"no-show"];
-		return [[[CDStandardInputboxControl alloc] initWithOptions:options] autorelease];
+		return [[[CDStandardInputboxControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"secure-inputbox"]) {
 		[extraOptions setObject:[NSNumber numberWithBool:NO] forKey:@"no-show"];
-		return [[[CDInputboxControl alloc] initWithOptions:options] autorelease];
+		return [[[CDInputboxControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"dropdown"]) {
-		return [[[CDPopUpButtonControl alloc] initWithOptions:options] autorelease];
+		return [[[CDPopUpButtonControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"standard-dropdown"]) {
-		return [[[CDStandardPopUpButtonControl alloc] initWithOptions:options] autorelease];
+		return [[[CDStandardPopUpButtonControl alloc] initWithOptionList:options] autorelease];
 	} else if ([runMode isEqualToString:@"bubble"]) {
-		return [[[CDBubbleControl alloc] initWithOptions:options] autorelease];
+		return [[[CDBubbleControl alloc] initWithOptionList:options] autorelease];
 	} else {
 		NSFileHandle *fh = [NSFileHandle fileHandleWithStandardOutput];
 		NSString *output = [NSString stringWithFormat:@"Unknown dialog type: %@\n", runMode]; 
