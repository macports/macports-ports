*** pwgen.c	Wed Jun  2 14:58:27 1999
--- pwgen.c.new	Fri May  9 10:02:14 2003
***************
*** 569,581 ****
    int is_bad_opt = 0; /* true if unrecognized option */
    int cnt, len, wants_secure=0;
    char buf[20];
- #ifdef ALLBYOPTS
    int wants_alternate_phonics = 0; /* boolean from options */
    int wants_capitalize = 0; /* boolean from options */
    int wants_numerals = 0; /* boolean from options */
    int wants_help = 0; /* boolean from options */
    int getopt_result;
    int longindex = 0;
  
    getopt_result = 
      getopt_long
--- 569,582 ----
    int is_bad_opt = 0; /* true if unrecognized option */
    int cnt, len, wants_secure=0;
    char buf[20];
    int wants_alternate_phonics = 0; /* boolean from options */
    int wants_capitalize = 0; /* boolean from options */
    int wants_numerals = 0; /* boolean from options */
    int wants_help = 0; /* boolean from options */
    int getopt_result;
    int longindex = 0;
+ 
+ #ifdef ALLBYOPTS
  
    getopt_result = 
      getopt_long
