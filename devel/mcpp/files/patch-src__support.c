diff -c -r -N ../mcpp-2.7.2/src/support.c ./src/support.c
*** ../mcpp-2.7.2/src/support.c	2008-06-10 06:02:33.000000000 -0230
--- ./src/support.c	2009-12-17 20:42:39.000000000 -0330
***************
*** 188,194 ****
      size_t      length
  )
  {
!     if (mem_buf_p->bytes_avail < length) {  /* Need to allocate more memory */
          size_t size = MAX( BUF_INCR_SIZE, length);
  
          if (mem_buf_p->buffer == NULL) {            /* 1st append   */
--- 188,194 ----
      size_t      length
  )
  {
!     if (mem_buf_p->bytes_avail < length + 1) {  /* Need to allocate more memory */
          size_t size = MAX( BUF_INCR_SIZE, length);
  
          if (mem_buf_p->buffer == NULL) {            /* 1st append   */
***************
*** 1722,1727 ****
--- 1722,1729 ----
                      sp -= 2;
                      while (*sp != '\n')     /* Until end of line    */
                          mcpp_fputc( *sp++, OUT);
+                     mcpp_fputc( '\n', OUT);
+                     wrong_line = TRUE;
                  }
                  goto  end_line;
              default:                        /* Not a comment        */
