--- src/lib/howl/MacOSX/macosx_salt.c.orig	Wed Mar 30 17:27:46 2005
+++ src/lib/howl/MacOSX/macosx_salt.c	Wed Mar 30 17:27:56 2005
@@ -66,6 +66,7 @@
 				char			**	argv)
 {
 	sw_result err = SW_OKAY;
+	pthread_mutexattr_t 	attrs;
 
 	*salt = (sw_salt) sw_malloc(sizeof(struct _sw_salt));
 	err = sw_translate_error(*salt, SW_E_MEM);
@@ -76,6 +77,8 @@
 	(*salt)->m_sockets.m_prev	=	NULL;
   	(*salt)->m_step				=	SW_FALSE;
 
+	pthread_mutexattr_settype(&attrs, PTHREAD_MUTEX_RECURSIVE);
+	pthread_mutex_init(&(*salt)->m_mutex, &attrs);
 	signal(SIGPIPE, SIG_IGN);
 
 exit:
@@ -178,6 +181,24 @@
 	}
 
 	return SW_OKAY;
+}
+
+
+sw_result
+sw_salt_lock(
+				sw_salt	self)
+{
+	sw_assert(self);
+	pthread_mutex_lock(&self->m_mutex);
+}
+
+
+sw_result
+sw_salt_unlock(
+				sw_salt	self)
+{
+	sw_assert(self);
+	pthread_mutex_unlock(&self->m_mutex);
 }
 
 
