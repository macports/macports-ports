--- src/misc.d	2005-11-28 18:32:51.000000000 -0500
+++ /Users/gwright/tmp/clisp/src/misc.d	2005-12-08 13:23:17.000000000 -0500
@@ -306,53 +306,17 @@
 local char * cat_env_var (char * buffer, const char * name, uintL namelen,
                           const char * value, uintL valuelen) {
   memcpy(buffer,name,namelen);
-#if defined(WIN32_NATIVE)
-  /* woe32: putenv("FOO=") removes FOO */
+  if (value == NULL) abort();
   buffer[namelen++] = '=';
-#endif
-  if (value != NULL) {
-   #if !defined(WIN32_NATIVE)
-    /* posix: putenv("FOO") removes FOO */
-    buffer[namelen++] = '=';
-   #endif
-    memcpy(buffer+namelen,value,valuelen);
-    buffer[namelen+valuelen] = 0;
-  } else
-    buffer[namelen] = 0;
+  memcpy(buffer+namelen,value,valuelen);
+  buffer[namelen+valuelen] = 0;
   return buffer;
 }
 
-/* Modify the environment variables. putenv() is POSIX, but some BSD systems
- only have setenv(). Therefore (and because it's simpler to use) we
- implement this interface, but without the third argument.
- clisp_setenv(name,value) sets the value of the environment variable `name'
- to `value' and returns 0. Returns -1 if not enough memory. */
-global int clisp_setenv (const char * name, const char * value) {
-  var uintL namelen = asciz_length(name);
-  var uintL valuelen = (value==NULL ? 0 : asciz_length(value));
-#if defined(WIN32_NATIVE)
-  /* On Woe32, each process has two copies of the environment variables,
-     one managed by the OS and one managed by the C library. We set
-     the value in both locations, so that other software that looks in
-     one place or the other is guaranteed to see the value. Even if it's
-     a bit slow. See also
-     <http://article.gmane.org/gmane.comp.gnu.mingw.user/8272>
-     <http://article.gmane.org/gmane.comp.gnu.mingw.user/8273>
-     <http://www.cygwin.com/ml/cygwin/1999-04/msg00478.html> */
-  if (!SetEnvironmentVariableA(name,value)
-      && (value || GetLastError() != ERROR_ENVVAR_NOT_FOUND))
-    return -1;
-#endif
-#if defined(HAVE_PUTENV)
-  var char* buffer = (char*)malloc(namelen+1+valuelen+1);
-  if (!buffer)
-    return -1; /* no need to set errno = ENOMEM */
-  return putenv(cat_env_var(buffer,name,namelen,value,valuelen));
-#elif defined(HAVE_SETENV)
-  return setenv(name,value,1);
-#else
-  /* Uh oh, neither putenv() nor setenv(), have to frob the environment
+/* Uh oh, neither putenv() nor setenv(), have to frob the environment
    ourselves. Routine taken from glibc and fixed in several aspects. */
+local int setenv_via_environ (const char * name, uintL namelen,
+                              const char * value, uintL valuelen) {
   var char** epp;
   var char* ep;
   var uintL envvar_count = 0;
@@ -402,9 +366,63 @@
     ep = (char*) malloc(namelen+1+valuelen+1);
     if (!ep)
       return -1; /* no need to set errno = ENOMEM */
-    *epp = cat_env_var(ep,name,namelen,value,valuelen);
+    if (value == NULL) *epp = NULL;
+    else *epp = cat_env_var(ep,name,namelen,value,valuelen);
   }
   return 0;
+}
+
+/* Modify the environment variables. putenv() is POSIX, but some BSD systems
+ only have setenv(). Therefore (and because it's simpler to use) we
+ implement this interface, but without the third argument.
+ clisp_setenv(name,value) sets the value of the environment variable `name'
+ to `value' and returns 0. Returns -1 if not enough memory. */
+global int clisp_setenv (const char * name, const char * value) {
+  var uintL namelen = asciz_length(name);
+  var uintL valuelen = (value==NULL ? 0 : asciz_length(value));
+#if defined(WIN32_NATIVE)
+  /* On Woe32, each process has two copies of the environment variables,
+     one managed by the OS and one managed by the C library. We set
+     the value in both locations, so that other software that looks in
+     one place or the other is guaranteed to see the value. Even if it's
+     a bit slow. See also
+     <http://article.gmane.org/gmane.comp.gnu.mingw.user/8272>
+     <http://article.gmane.org/gmane.comp.gnu.mingw.user/8273>
+     <http://www.cygwin.com/ml/cygwin/1999-04/msg00478.html> */
+  if (!SetEnvironmentVariableA(name,value)
+      && (value || GetLastError() != ERROR_ENVVAR_NOT_FOUND))
+    return -1;
+#endif
+#if defined(HAVE_UNSETENV)
+  if (value == NULL)
+   #if UNSETENV_POSIX
+    return unsetenv(name);
+   #else
+    { unsetenv(name); return 0; }
+   #endif
+#endif
+#if defined(HAVE_PUTENV)
+  if (value == NULL) {
+    putenv((char*)name);
+    if (getenv(name) != NULL)
+      /* putenv(name) may silently fail - as on *BSD (which have unsetenv)
+         Solaris & woe32 do not have unsetenv
+         _and_ putenv(name) does not work */
+      setenv_via_environ(name,namelen,NULL,0);
+    /* putenv("FOO=") unsets FOO on woe32 - but why bother? */
+    return 0;
+  } else {
+    var char* buffer = (char*)malloc(namelen+1+valuelen+1);
+    if (!buffer)
+      return -1; /* no need to set errno = ENOMEM */
+    return putenv(cat_env_var(buffer,name,namelen,value,valuelen));
+  }
+#elif defined(HAVE_SETENV)
+  /* setenv(name,NULL,1) ==> segfault */
+  if (value == NULL) return setenv_via_environ(name,namelen,NULL,0);
+  else return setenv(name,value,1);
+#else
+  return setenv_via_environ(name,namelen,value,valuelen);
 #endif
 }
 
