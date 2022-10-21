/*
 * Copyright (c) 2004 Apple Computer, Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_LICENSE_HEADER_END@
 */
#ifndef _COPYFILE_H_ /* version 0.1 */
#define _COPYFILE_H_

/*
 * this is a proposed API to add to libSystem to faciliatate copying
 * of files and their associated metadata.  There are several open
 * source projects that need modifications to support preserving
 * extended attributes and acls and this API collapses several hundred
 * lines of modifications into one or two calls.
 *
 * This implementation is incomplete and the interface may change in a 
 * future release.
 */

/* private */
#include <stdint.h>
struct _copyfile_state;
typedef struct _copyfile_state * copyfile_state_t;
typedef uint32_t copyfile_flags_t;

/* public */

/* receives:
 *   from	path to source file system object
 *   to		path to destination file system object
 *   state	opaque blob for future extensibility
 *		Must be NULL in current implementation
 *   flags	(described below)
 * returns:
 *   int	negative for error
 */

int copyfile(const char *from, const char *to, copyfile_state_t state, copyfile_flags_t flags);
int copyfile_free(copyfile_state_t);
copyfile_state_t copyfile_init(void);

/* Flag for clients to disable their use of copyfile() */
#define COPYFILE_DISABLE_VAR	"COPY_EXTENDED_ATTRIBUTES_DISABLE"

/* flags for copyfile */

#define COPYFILE_ACL	    (1<<0)
#define COPYFILE_STAT	    (1<<1)
#define COPYFILE_XATTR	    (1<<2)
#define COPYFILE_DATA	    (1<<3)

#define COPYFILE_SECURITY   (COPYFILE_STAT | COPYFILE_ACL)
#define COPYFILE_METADATA   (COPYFILE_SECURITY | COPYFILE_XATTR)
#define COPYFILE_ALL	    (COPYFILE_METADATA | COPYFILE_DATA)

#define COPYFILE_CHECK		(1<<16) /* return flags for xattr or acls if set */
#define COPYFILE_EXCL		(1<<17) /* fail if destination exists */
#define COPYFILE_NOFOLLOW_SRC	(1<<18) /* don't follow if source is a symlink */
#define COPYFILE_NOFOLLOW_DST	(1<<19) /* don't follow if dst is a symlink */
#define COPYFILE_MOVE		(1<<20) /* unlink src after copy */
#define COPYFILE_UNLINK		(1<<21) /* unlink dst before copy */
#define COPYFILE_NOFOLLOW	(COPYFILE_NOFOLLOW_SRC | COPYFILE_NOFOLLOW_DST)

#define COPYFILE_PACK		(1<<22)
#define COPYFILE_UNPACK		(1<<23)

#define COPYFILE_VERBOSE	(1<<30)

#endif /* _COPYFILE_H_ */
