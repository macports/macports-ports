--- ../include/mutex.h.orig	Sun May  6 21:19:20 2001
+++ ../include/mutex.h	Sat Mar  6 10:31:57 2004
@@ -482,6 +482,43 @@
  * 'set' mutexes have the value 1, like on Intel; the returned value from
  * MUTEX_SET() is 1 if the mutex previously had its low bit clear, 0 otherwise.
  */
+
+/*
+ * Note from http://cvs.osafoundation.org/index.cgi/osaf/chandler/persistence/db/dbinc/mutex.h?rev=HEAD
+ * by Andi Vajda <andi at osafoundation dot org>
+ * 
+ * Mutexes on Mac OS X work the same way as the standard PowerPC version, but
+ * the assembler syntax is subtly different -- the standard PowerPC version
+ * assembles but doesn't work correctly.  This version makes (unnecessary?)
+ * use of a stupid linker trick: __db_mutex_tas_dummy is never called, but the
+ * ___db_mutex_set label is used as a function name.
+ */
+
+#if defined(__APPLE__) && defined(__MACH__) && defined(__ppc__)
+#warning "Using apple specific mutexes" 
+extern int __db_mutex_set __P((volatile tsl_t *));
+void
+__db_mutex_tas_dummy()
+{
+	__asm__	__volatile__("		\n\
+	.globl 	___db_mutex_set		\n\
+___db_mutex_set:			\n\
+	lwarx	r5,0,r3			\n\
+	cmpwi 	r5,0			\n\
+	bne 	fail			\n\
+	addi 	r5,r5,1			\n\
+	stwcx. 	r5,0,r3			\n\
+	beq 	success			\n\
+fail:					\n\
+	li 	r3,0			\n\
+	blr 				\n\
+success:				\n\
+	li 	r3,1			\n\
+	blr");	
+}
+#define	MUTEX_SET(tsl)  __db_mutex_set(tsl)
+#else
+ 
 #define	MUTEX_SET(tsl)	({		\
 	int __one = 1;			\
 	int __r;			\
@@ -499,6 +536,7 @@
 	!(__r & 1);			\
 })
 
+#endif
 #define	MUTEX_UNSET(tsl)	(*(tsl) = 0)
 #define	MUTEX_INIT(tsl)		MUTEX_UNSET(tsl)
 #endif
