*** getifname.c.org	Mon Apr 21 15:01:28 2003
--- getifname.c	Mon Apr 21 15:37:18 2003
***************
*** 15,21 ****
  #include <net/if.h>
  #include <unistd.h>		/* close */
  
! #if defined(__FreeBSD__) || defined(__OpenBSD__) || defined(__NetBSD__)
  #include <stdlib.h>
  #include <ifaddrs.h>
  #endif /* defined(__*BSD__) */
--- 15,23 ----
  #include <net/if.h>
  #include <unistd.h>		/* close */
  
! #define __Darwin__
! 
! #if defined(__Darwin__) || defined(__FreeBSD__) || defined(__OpenBSD__) || defined(__NetBSD__)
  #include <stdlib.h>
  #include <ifaddrs.h>
  #endif /* defined(__*BSD__) */
***************
*** 23,29 ****
  #include "hping2.h"
  #include "globals.h"
  
! #if !defined(__FreeBSD__) && !defined(__OpenBSD__) && !defined(__NetBSD__) && !defined(__linux__) && !defined(__sun__)
  #error Sorry, interface code not implemented.
  #endif
  
--- 25,31 ----
  #include "hping2.h"
  #include "globals.h"
  
! #if !defined(__Darwin__) && !defined(__FreeBSD__) && !defined(__OpenBSD__) && !defined(__NetBSD__) && !defined(__linux__) && !defined(__sun__)
  #error Sorry, interface code not implemented.
  #endif
  
***************
*** 169,175 ****
  	return 0;
  }
  
! #elif defined(__FreeBSD__) || defined(__NetBSD__) || defined(__OpenBSD__)
  
  /* return interface informations :
     - from the specified (-I) interface
--- 171,177 ----
  	return 0;
  }
  
! #elif defined(__Darwin__) || defined(__FreeBSD__) || defined(__NetBSD__) || defined(__OpenBSD__)
  
  /* return interface informations :
     - from the specified (-I) interface
