--- patch.c	2004/09/10 02:48:58	1.30
+++ patch.c	2006/03/10 10:44:10	1.31
@@ -1,7 +1,7 @@
 /*= -*- c-basic-offset: 4; indent-tabs-mode: nil; -*-
  *
  * librsync -- the library for network deltas
- * $Id: patch.c,v 1.30 2004/09/10 02:48:58 mbp Exp $
+ * $Id: patch.c,v 1.31 2006/03/10 10:44:10 abo Exp $
  * 
  * Copyright (C) 2000, 2001 by Martin Pool <mbp@samba.org>
  * 
@@ -214,12 +214,9 @@
     void            *buf, *ptr;
     rs_buffers_t    *buffs = job->stream;
 
-    len = job->basis_len;
-    
     /* copy only as much as will fit in the output buffer, so that we
      * don't have to block or store the input. */
-    if (len > buffs->avail_out)
-        len = buffs->avail_out;
+    len = (buffs->avail_out < job->basis_len) ? buffs->avail_out : job->basis_len;
 
     if (!len)
         return RS_BLOCKED;
