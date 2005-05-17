*** Include/pyport.h	Mon May 16 21:36:35 2005
--- Include/pyport.h	Mon May 16 21:47:28 2005
***************
*** 152,162 ****
--- 152,174 ----
  #if defined(PYOS_OS2) && defined(PYCC_GCC)
  #include <sys/types.h>
  #endif
+ 
+ #if (defined __APPLE__) && (!defined _POSIX_C_SOURCE)
+ #define TEMPORARILY_DEFINING__POSIX_C_SOURCE    /* so we can #undef it later */
+ #define _POSIX_C_SOURCE   /* avoid deprecated struct ostat in sys/stat.h */
+ #endif
+ 
  #include <sys/stat.h>
  #elif defined(HAVE_STAT_H)
  #include <stat.h>
  #endif
  
+ /* Mac OS X: undefine _POSIX_C_SOURCE if it wasn't defined before */
+ #ifdef TEMPORARILY_DEFINING__POSIX_C_SOURCE
+ #undef _POSIX_C_SOURCE
+ #undef TEMPORARILY_DEFINING__POSIX_C_SOURCE
+ #endif
+ 
  #if defined(PYCC_VACPP)
  /* VisualAge C/C++ Failed to Define MountType Field in sys/stat.h */
  #define S_IFMT (S_IFDIR|S_IFCHR|S_IFREG)
