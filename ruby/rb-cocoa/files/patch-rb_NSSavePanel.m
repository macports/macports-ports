--- framework/src/objc/cocoa/rb_NSSavePanel.m.orig	Fri Jan 16 15:57:24 2004
+++ framework/src/objc/cocoa/rb_NSSavePanel.m	Fri Jan 16 15:58:29 2004
@@ -11,14 +11,14 @@
 void init_NSSavePanel(VALUE mOSX)
 {
   /**** enums ****/
-  rb_define_const(mOSX, "NSFileHandlingPanelImageButton", INT2NUM(NSFileHandlingPanelImageButton));
-  rb_define_const(mOSX, "NSFileHandlingPanelTitleField", INT2NUM(NSFileHandlingPanelTitleField));
-  rb_define_const(mOSX, "NSFileHandlingPanelBrowser", INT2NUM(NSFileHandlingPanelBrowser));
+//  rb_define_const(mOSX, "NSFileHandlingPanelImageButton", INT2NUM(NSFileHandlingPanelImageButton));
+//  rb_define_const(mOSX, "NSFileHandlingPanelTitleField", INT2NUM(NSFileHandlingPanelTitleField));
+//  rb_define_const(mOSX, "NSFileHandlingPanelBrowser", INT2NUM(NSFileHandlingPanelBrowser));
   rb_define_const(mOSX, "NSFileHandlingPanelCancelButton", INT2NUM(NSFileHandlingPanelCancelButton));
   rb_define_const(mOSX, "NSFileHandlingPanelOKButton", INT2NUM(NSFileHandlingPanelOKButton));
-  rb_define_const(mOSX, "NSFileHandlingPanelForm", INT2NUM(NSFileHandlingPanelForm));
-  rb_define_const(mOSX, "NSFileHandlingPanelHomeButton", INT2NUM(NSFileHandlingPanelHomeButton));
-  rb_define_const(mOSX, "NSFileHandlingPanelDiskButton", INT2NUM(NSFileHandlingPanelDiskButton));
-  rb_define_const(mOSX, "NSFileHandlingPanelDiskEjectButton", INT2NUM(NSFileHandlingPanelDiskEjectButton));
+//  rb_define_const(mOSX, "NSFileHandlingPanelForm", INT2NUM(NSFileHandlingPanelForm));
+//  rb_define_const(mOSX, "NSFileHandlingPanelHomeButton", INT2NUM(NSFileHandlingPanelHomeButton));
+//  rb_define_const(mOSX, "NSFileHandlingPanelDiskButton", INT2NUM(NSFileHandlingPanelDiskButton));
+//  rb_define_const(mOSX, "NSFileHandlingPanelDiskEjectButton", INT2NUM(NSFileHandlingPanelDiskEjectButton));
 
 }
