--- FormatHelper.m	2005-09-23 14:16:33.000000000 -0500
+++ FormatHelper.m	2005-09-23 14:18:03.000000000 -0500
@@ -334,6 +334,8 @@
             return getStringForLabel(person, kABFirstNameProperty, nil);
         case 'l':
             return getStringForLabel(person, kABLastNameProperty, nil);
+        case 'm':
+            return getStringForLabel(person, kABMiddleNameProperty, nil);
         case 'n':
             return getStringForLabel(person, kABNicknameProperty, nil);
         default:
--- contacts.1	2005-09-23 14:25:25.000000000 -0500
+++ contacts.1	2005-09-23 14:25:59.000000000 -0500
@@ -53,6 +53,8 @@
 first name
 .It %ln               \" Each item preceded by .It macro
 last name
+.It %mn               \" Each item preceded by .It macro
+middle name
 .It %nn               \" Each item preceded by .It macro
 nick name
 .It %p                \" Each item preceded by .It macro
