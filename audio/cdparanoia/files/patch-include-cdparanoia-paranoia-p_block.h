--- ../cdparanoia-0.9.8.orig/include/cdparanoia/paranoia/p_block.h	Fri Apr  8 19:35:10 2005
+++ include/cdparanoia/paranoia/p_block.h	Fri Apr  8 19:35:18 2005
@@ -128,7 +128,7 @@
 
 } offsets;
 
-typedef struct cdrom_paranoia{
+struct cdrom_paranoia {
   cdrom_drive *d;
 
   root_block root;        /* verified/reconstructed cached data */
@@ -155,7 +155,7 @@
 
   /* statistics for verification */
 
-} cdrom_paranoia;
+};
 
 extern c_block *c_alloc(int16_t *vector,long begin,long size);
 extern void c_set(c_block *v,long begin);
@@ -171,8 +171,8 @@
 
 /* pos here is vector position from zero */
 
-extern void recover_cache(cdrom_paranoia *p);
-extern void i_paranoia_firstlast(cdrom_paranoia *p);
+extern void recover_cache(struct cdrom_paranoia *p);
+extern void i_paranoia_firstlast(struct cdrom_paranoia *p);
 
 #define cv(c) (c->vector)
 
