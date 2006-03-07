--- lib/tree.hh.orig	2006-03-05 09:56:39.000000000 -0500
+++ lib/tree.hh	2006-03-04 17:38:49.000000000 -0500
@@ -69,7 +69,7 @@
    }
 
 template <class T1>
-inline void kp::destructor(T1* p)
+inline void destructor(T1* p)
    {
    p->~T1();
    }
