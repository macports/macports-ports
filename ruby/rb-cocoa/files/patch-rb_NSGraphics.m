--- framework/src/objc/cocoa/rb_NSGraphics.m.orig	Fri Jan 16 15:52:00 2004
+++ framework/src/objc/cocoa/rb_NSGraphics.m	Fri Jan 16 15:52:17 2004
@@ -1480,8 +1480,8 @@
   rb_define_const(mOSX, "NSCompositePlusDarker", INT2NUM(NSCompositePlusDarker));
   rb_define_const(mOSX, "NSCompositeHighlight", INT2NUM(NSCompositeHighlight));
   rb_define_const(mOSX, "NSCompositePlusLighter", INT2NUM(NSCompositePlusLighter));
-  rb_define_const(mOSX, "NSAlphaEqualToData", INT2NUM(NSAlphaEqualToData));
-  rb_define_const(mOSX, "NSAlphaAlwaysOne", INT2NUM(NSAlphaAlwaysOne));
+//  rb_define_const(mOSX, "NSAlphaEqualToData", INT2NUM(NSAlphaEqualToData));
+//  rb_define_const(mOSX, "NSAlphaAlwaysOne", INT2NUM(NSAlphaAlwaysOne));
   rb_define_const(mOSX, "NSBackingStoreRetained", INT2NUM(NSBackingStoreRetained));
   rb_define_const(mOSX, "NSBackingStoreNonretained", INT2NUM(NSBackingStoreNonretained));
   rb_define_const(mOSX, "NSBackingStoreBuffered", INT2NUM(NSBackingStoreBuffered));
