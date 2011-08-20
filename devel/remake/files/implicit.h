/** \file implicit.h
 *
 *  \brief header for impilict.c
 */

#ifndef REMAKE_IMPLICIT_H
#define REMAKE_IMPLICIT_H

#include "types.h"
/* For a FILE which has no commands specified, try to figure out some
   from the implicit pattern rules.
   Returns 1 if a suitable implicit rule was found,
   after modifying FILE to contain the appropriate commands and deps,
   or returns 0 if no implicit rule was found.  */
extern int try_implicit_rule (file_t *file, unsigned int depth);
#endif

