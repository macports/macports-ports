--- gnome-terminal/vt.c.org	2006-08-28 05:21:42.000000000 -0700
+++ gnome-terminal/vt.c	2006-08-28 05:25:06.000000000 -0700
@@ -781,7 +781,7 @@
       vt_cr(vt);
       vt_up(vt);    
       break;
-    default:
+    default:;
     }
 
 }
@@ -805,7 +805,7 @@
       vt_cr(vt);
       vt_down(vt);
       break;
-    default:
+    default:;
     }
 }
 
@@ -869,7 +869,7 @@
 	  break; 
 	}
       break; 
-    default:
+    default:;
     }
 }
 
@@ -955,7 +955,7 @@
 	    vt->cursorx = vt_tab_prev(vt, vt->cursorx);
 	} 
       break;
-    default:
+    default:;
     }
     /*vt->cursorx = (vt->cursorx-1) & (~7);*/
 }
@@ -979,7 +979,7 @@
 	  i--;
 	} 
      break; 
-    default:
+    default:;
     } 
 }
 
@@ -2072,10 +2072,10 @@
 	     } 
 */	      
 	break;
-	default:
+	default:;
 	}
       break;
-	default:
+	default:;
     } 
   /* do nothing!*/
 }
