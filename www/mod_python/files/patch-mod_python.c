--- src/mod_python.c	Mon Feb 16 20:47:27 2004
+++ /Users/mww/Desktop/mod_python.c	Wed Mar 16 21:15:49 2005
@@ -31,6 +31,10 @@
  * (In a Python dictionary) */
 static PyObject * interpreters = NULL;
 
+#ifdef WITH_THREAD
+static apr_thread_mutex_t* interpreters_lock = 0;
+#endif
+
 apr_pool_t *child_init_pool = NULL;
 
 /**
@@ -124,6 +128,8 @@
         name = MAIN_INTERPRETER;
 
 #ifdef WITH_THREAD
+    apr_thread_mutex_lock(interpreters_lock);
+
     PyEval_AcquireLock();
 #endif
 
@@ -149,6 +155,8 @@
 
 #ifdef WITH_THREAD
     PyEval_ReleaseLock();
+
+    apr_thread_mutex_unlock(interpreters_lock);
 #endif
 
     if (! idata) {
@@ -469,6 +477,9 @@
     const char *userdata_key = "python_init";
     apr_status_t rc;
 
+    /* fudge for Mac OS X with Apache where Py_IsInitialized() broke */
+    static int initialized = 0;
+
     apr_pool_userdata_get(&data, userdata_key, s->process->pool);
     if (!data) {
         apr_pool_userdata_set((const void *)1, userdata_key,
@@ -490,13 +501,16 @@
     }
 
     /* initialize global Python interpreter if necessary */
-    if (! Py_IsInitialized()) 
+    if (initialized == 0 || ! Py_IsInitialized()) 
     {
+        initialized = 1;
 
         /* initialze the interpreter */
         Py_Initialize();
 
 #ifdef WITH_THREAD
+        apr_thread_mutex_create(&interpreters_lock,APR_THREAD_MUTEX_UNNESTED,p);
+
         /* create and acquire the interpreter lock */
         PyEval_InitThreads();
 #endif
