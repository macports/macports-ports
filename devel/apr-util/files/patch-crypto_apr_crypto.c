--- crypto/apr_crypto.c
+++ crypto/apr_crypto.c
@@ -194,6 +194,10 @@ static volatile const apr_uint32_t optblocker;
  * Paper:
  *   https://cr.yp.to/papers/cryptoint-20250424.pdf
  */
+#ifndef __has_attribute
+#define __has_attribute(__x)    0
+#endif
+
 #if __has_attribute(always_inline)
 __attribute__((always_inline))
 #endif
--- crypto/apr_passwd.c
+++ crypto/apr_passwd.c
@@ -64,11 +64,9 @@ static volatile const apr_uint32_t optblocker;
  * Paper:
  *   https://cr.yp.to/papers/cryptoint-20250424.pdf
  */
-#if (defined(__xlc__) && !defined(__GNUC__))
 #ifndef __has_attribute
 #define __has_attribute(__x)    0
 #endif
-#endif
 
 #if __has_attribute(always_inline)
 __attribute__((always_inline))
