--- mdfour.h	2003/10/17 16:15:21	1.7
+++ mdfour.h	2006/03/10 10:44:10	1.8
@@ -1,7 +1,7 @@
 /*= -*- c-basic-offset: 4; indent-tabs-mode: nil; -*-
  *
  * librsync -- the library for network deltas
- * $Id: mdfour.h,v 1.7 2003/10/17 16:15:21 abo Exp $
+ * $Id: mdfour.h,v 1.8 2006/03/10 10:44:10 abo Exp $
  * 
  * Copyright (C) 2000, 2001 by Martin Pool <mbp@samba.org>
  * Copyright (C) 2002, 2003 by Donovan Baarda <abo@minkirri.apana.org.au> 
@@ -24,7 +24,7 @@
 #include "types.h"
 
 struct rs_mdfour {
-    int                 A, B, C, D;
+    unsigned int        A, B, C, D;
 #if HAVE_UINT64
     uint64_t            totalN;
 #else
