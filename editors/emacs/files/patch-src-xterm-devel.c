--- emacs/src/xterm.c	Fri Dec 31 19:16:10 2004
+++ emacs/src/xterm.c.new	Wed Jan 12 15:56:13 2005
@@ -4731,7 +4731,7 @@
 	  XawScrollbarSetThumb (widget, top, shown);
 	else
 	  {
-#ifdef HAVE_XAW3D
+#if defined(HAVE_XAW3D) && defined(XAW_ARROW_SCROLLBARS)
 	    ScrollbarWidget sb = (ScrollbarWidget) widget;
 	    int scroll_mode = 0;
 
@@ -4751,7 +4751,7 @@
 
 	    XawScrollbarSetThumb (widget, top, shown);
 
-#ifdef HAVE_XAW3D
+#if defined(HAVE_XAW3D) && defined(XAW_ARROW_SCROLLBARS)
 	    if (xaw3d_arrow_scroll && scroll_mode == 2)
 	      sb->scrollbar.scroll_mode = scroll_mode;
 #endif
