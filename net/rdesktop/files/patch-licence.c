*** licence.c.orig	2006-04-10 19:20:26.000000000 +0200
--- licence.c	2006-04-10 19:20:51.000000000 +0200
***************
*** 113,119 ****
  
  	out_uint32_le(s, 1);
  	out_uint16(s, 0);
! 	out_uint16_le(s, 0xff01);
  
  	out_uint8p(s, client_random, SEC_RANDOM_SIZE);
  	out_uint16(s, 0);
--- 113,121 ----
  
  	out_uint32_le(s, 1);
  	out_uint16(s, 0);
! 	
! 	/* 0xff01 == any Windows TSC, 0x0301 == Windows 2K */
! 	out_uint16_le(s, 0x0301);
  
  	out_uint8p(s, client_random, SEC_RANDOM_SIZE);
  	out_uint16(s, 0);
