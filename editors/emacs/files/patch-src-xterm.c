--- emacs-21.3/src/xterm.c	Tue Oct 15 16:21:45 2002
+++ emacs-21.3/src/xterm-fixed.c	Wed Jan 12 15:14:07 2005
@@ -8863,7 +8863,7 @@
 	  XawScrollbarSetThumb (widget, top, shown);
 	else
 	  {
-#ifdef HAVE_XAW3D
+#if defined(HAVE_XAW3D) && defined(XAW_ARROW_SCROLLBARS)
 	    ScrollbarWidget sb = (ScrollbarWidget) widget;
 	    int scroll_mode = 0;
 	    
@@ -8883,7 +8883,7 @@
 	    
 	    XawScrollbarSetThumb (widget, top, shown);
 	    
-#ifdef HAVE_XAW3D
+#if defined(HAVE_XAW3D) && defined(XAW_ARROW_SCROLLBARS)
 	    if (xaw3d_arrow_scroll && scroll_mode == 2)
 	      sb->scrollbar.scroll_mode = scroll_mode;
 #endif
