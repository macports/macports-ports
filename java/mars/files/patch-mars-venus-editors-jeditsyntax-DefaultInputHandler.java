--- mars/venus/editors/jeditsyntax/DefaultInputHandler.java.orig	2013-03-07 17:51:06.000000000 +0100
+++ mars/venus/editors/jeditsyntax/DefaultInputHandler.java	2013-03-07 18:21:45.000000000 +0100
@@ -14,6 +14,7 @@
    import java.awt.Toolkit;
    import java.util.Hashtable;
    import java.util.StringTokenizer;
+   import java.util.Properties;
 
 /**
  * The default input handler. It maps sequences of keystrokes into actions
@@ -232,19 +233,45 @@
          // matches KeyEvent.META_MASK.   DPS 30-Nov-2010
          if ((modifiers & KeyEvent.META_MASK) != 0) 
             return;
-      // DPS 9-Jan-2013.  Umberto Villano from Italy describes Alt combinations
-      // not working on Italian Mac keyboards, where # requires Alt (Option).
-		// This is preventing him from writing comments.  Similar complaint from
-		// Joachim Parrow in Sweden, only for the $ character.  Villano pointed
-		// me to this method.  Plus a Google search on "jeditsyntax alt key"
-		// (without quotes) took me to
-		// http://compgroups.net/comp.lang.java.programmer/option-key-in-jedit-syntax-package/1068227
-		// which says to comment out the second condition in this IF statement:
-      // if(c != KeyEvent.CHAR_UNDEFINED && (modifiers & KeyEvent.ALT_MASK) == 0)
-		// So let's give it a try!
-		// (...later) Bummer, it results in keystroke echoed into editing area when I use Alt
-		// combination for shortcut menu access (e.g. Alt+f to open the File menu).
-         if(c != KeyEvent.CHAR_UNDEFINED && (modifiers & KeyEvent.ALT_MASK) == 0)
+         // DPS 9-Jan-2013.  Umberto Villano from Italy describes Alt combinations
+         // not working on Italian Mac keyboards, where # requires Alt (Option).
+         // This is preventing him from writing comments.  Similar complaint from
+         // Joachim Parrow in Sweden, only for the $ character.  Villano pointed
+         // me to this method.  Plus a Google search on "jeditsyntax alt key"
+         // (without quotes) took me to
+         // http://compgroups.net/comp.lang.java.programmer/option-key-in-jedit-syntax-package/1068227
+         // which says to comment out the second condition in this IF statement:
+         // if(c != KeyEvent.CHAR_UNDEFINED && (modifiers & KeyEvent.ALT_MASK) == 0)
+         // So let's give it a try!
+         // (...later) Bummer, it results in keystroke echoed into editing area when I use Alt
+         // combination for shortcut menu access (e.g. Alt+f to open the File menu).
+         //
+         // Torsten Maehne: This is a shortcoming of the menu
+         // shortcuts handling in the jedit component: It assumes that
+         // modifier keys are the same across all platforms. However,
+         // the menu shortcut keymask varies between OS X and
+         // Windows/Linux, it is Cmd + <key> instead of Alt +
+         // <key>. The "Java Development Guide for Mac" explicitly
+         // discusses the issue in:
+         // <https://developer.apple.com/library/mac/#documentation/Java/Conceptual/Java14Development/07-NativePlatformIntegration/NativePlatformIntegration.html#//apple_ref/doc/uid/TP40001909-211884-TPXREF130>
+         //
+         // As jedit always considers Alt + <key> as a keyboard
+         // shortcut, they block their output in the editor, which
+         // prevents the entry of special characters on OS X that uses
+         // Alt + <key> for this purpose instead of AltGr + <key>, as
+         // on Windows or Linux.
+         //
+         // For the latest jedit version (5.0.0), the menu
+         // accelerators don't work on OS X, at least the special
+         // characters can be entered using Alt + <key>. The issue is
+         // still open, but there seems to be progress:
+         //
+         // http://sourceforge.net/tracker/index.php?func=detail&aid=3558572&group_id=588&atid=300588
+         // http://sourceforge.net/tracker/?func=detail&atid=300588&aid=3604532&group_id=588
+         //
+         // Until this is resolved upstream, don't ignore characters
+         // on OS X, which have been entered with the ALT modifier:
+         if(c != KeyEvent.CHAR_UNDEFINED && (((modifiers & KeyEvent.ALT_MASK) == 0) || System.getProperty("os.name").contains("OS X")))
          {
             if(c >= 0x20 && c != 0x7f)
             { 
