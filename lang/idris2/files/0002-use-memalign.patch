From 8bfe6b92fc0f9f28c4922f0aeb21020084212c74 Mon Sep 17 00:00:00 2001
From: "Hattori, Hiroki" <seagull.kamome@gmail.com>
Date: Tue, 4 Nov 2025 10:48:21 +0900
Subject: [PATCH] Fix #3662 (#3665)

* [RefC] FIx #3662. Use posix_memalign instead of aligned_alloc under MacOS.

* fix linter error
---
 support/refc/memoryManagement.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/support/refc/memoryManagement.c b/support/refc/memoryManagement.c
index 157a212a1e7..17160f6210b 100644
--- support/refc/memoryManagement.c
+++ support/refc/memoryManagement.c
@@ -43,11 +43,24 @@ void idris2_dumpMemoryStats() {}
 #endif
 
 Value *idris2_newValue(size_t size) {
-#if !defined(_WIN32) && defined(__STDC_VERSION__) &&                           \
-    (__STDC_VERSION__ >= 201112) /* C11 */
+  /* Try to get memory aligned to pointer-size. Prefer C11 aligned_alloc
+     (not available on some platforms like older macOS), then posix_memalign,
+     and finally fall back to malloc which typically returns pointer-aligned
+     memory suitable for our needs. */
+#if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 201112L) &&              \
+    !defined(__APPLE__) && !defined(_WIN32)
   Value *retVal = (Value *)aligned_alloc(
       sizeof(void *),
       ((size + sizeof(void *) - 1) / sizeof(void *)) * sizeof(void *));
+#elif ((defined(_POSIX_C_SOURCE) && (_POSIX_C_SOURCE >= 200112L)) ||           \
+       (defined(_XOPEN_SOURCE) && (_XOPEN_SOURCE >= 600))) &&                  \
+    !defined(_WIN32)
+  Value *retVal = NULL;
+  IDRIS2_REFC_VERIFY(
+      posix_memalign((void **)&retVal, sizeof(void *),
+                     ((size + sizeof(void *) - 1) / sizeof(void *)) *
+                         sizeof(void *)) == 0,
+      "posix_memalign failed");
 #else
   Value *retVal = (Value *)malloc(size);
 #endif
