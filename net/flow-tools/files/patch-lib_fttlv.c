--- lib/fttlv.c.orig	Mon Oct  2 12:27:59 2006
+++ lib/fttlv.c	Mon Oct  2 12:30:50 2006
@@ -68,10 +68,10 @@
   }
 
   bcopy(&t, buf, 2);
-  (char*)buf+= 2;
+  buf = (char *)buf + 2;
 
   bcopy(&len, buf, 2);
-  (char*)buf+= 2;
+  buf = (char *)buf + 2;
 
   bcopy(&v, buf, 4);
 
@@ -107,10 +107,10 @@
   }
 
   bcopy(&t, buf, 2);
-  (char*)buf+= 2;
+  buf = (char *)buf + 2;
 
   bcopy(&len, buf, 2);
-  (char*)buf+= 2;
+  buf = (char *)buf + 2;
 
   bcopy(&v, buf, 2);
 
@@ -145,10 +145,10 @@
   }
 
   bcopy(&t, buf, 2);
-  (char*)buf+= 2;
+  buf = (char *)buf + 2;
 
   bcopy(&len, buf, 2);
-  (char*)buf+= 2;
+  buf = (char *)buf + 2;
 
   bcopy(&v, buf, 1);
 
@@ -183,10 +183,10 @@
   }
 
   bcopy(&t, buf, 2);
-  (char*)buf+= 2;
+  buf = (char *)buf + 2;
 
   bcopy(&len, buf, 2);
-  (char*)buf+= 2;
+  buf = (char *)buf + 2;
 
   bcopy(v, buf, len);
 
@@ -230,16 +230,16 @@
     return -1;
 
   bcopy(&t, buf, 2);
-  (char*)buf+= 2;
+  buf = (char *)buf + 2;
 
   bcopy(&len, buf, 2);
-  (char*)buf+= 2;
+  buf = (char *)buf + 2;
 
   bcopy(&ip, buf, 4);
-  (char*)buf += 4;
+  buf = (char *)buf + 4;
 
   bcopy(&ifIndex, buf, 2);
-  (char*)buf += 2;
+  buf = (char *)buf + 2;
 
   bcopy(name, buf, n);
 
@@ -287,19 +287,19 @@
   }
 
   bcopy(&t, buf, 2);
-  (char*)buf+= 2;
+  buf = (char *)buf + 2;
 
   bcopy(&len, buf, 2);
-  (char*)buf+= 2;
+  buf = (char *)buf + 2;
 
   bcopy(&ip, buf, 4);
-  (char*)buf += 4;
+  buf = (char *)buf + 4;
 
   bcopy(&entries, buf, 2);
-  (char*)buf += 2;
+  buf = (char *)buf + 2;
 
   bcopy(ifIndex_list, buf, esize);
-  (char*)buf += esize;
+  buf = (char *)buf + esize;
 
   bcopy(name, buf, n);
 
