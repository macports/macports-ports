#include <string.h>
#include "strnlen.h"

size_t strnlen(const char *s, size_t n) {
   const char *p = (const char *)memchr(s, 0, n);
   return(p ? p-s : n);
}

