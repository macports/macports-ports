--- Src/Builtins/rlimits.c.orig	2005-04-03 04:17:31.000000000 -0400
+++ Src/Builtins/rlimits.c	2005-04-03 04:18:33.000000000 -0400
@@ -242,7 +242,7 @@
 # endif /* HAVE_RLIMIT_MEMLOCK */
 /* If RLIMIT_VMEM and RLIMIT_RSS are defined and equal, avoid *
  * duplicate case statement.  Observed on QNX Neutrino 6.1.0. */
-# if defined(HAVE_RLIMIT_RSS) && !defined(RLIMIT_VMEM_IS_RSS)
+# if defined(HAVE_RLIMIT_RSS) && !defined(RLIMIT_VMEM_IS_RSS) && !defined(RLIMIT_RSS_IS_AS)
     case RLIMIT_RSS:
 	if (head)
 	    printf("-m: resident set size (kbytes) ");
@@ -834,7 +834,7 @@
 	    case RLIMIT_VMEM:
 # endif /* HAVE_RLIMIT_VMEM */
 /* ditto RLIMIT_VMEM and RLIMIT_AS */
-# if defined(HAVE_RLIMIT_AS) && !defined(RLIMIT_VMEM_IS_AS)
+# if defined(HAVE_RLIMIT_AS) && !defined(RLIMIT_VMEM_IS_AS) && !defined(RLIMIT_RSS_IS_AS)
 	    case RLIMIT_AS:
 # endif /* HAVE_RLIMIT_AS */
 # ifdef HAVE_RLIMIT_AIO_MEM
