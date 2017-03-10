/* Rename a file relative to open directories.
   Copyright (C) 2009-2017 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* written by Eric Blake */

#include <config.h>

#include <stdio.h>

#if HAVE_RENAMEAT

# include <errno.h>
# include <stdbool.h>
# include <stdlib.h>
# include <string.h>
# include <sys/stat.h>

# include "dirname.h"
# include "openat.h"

# undef renameat

/* renameat does not honor trailing / on Solaris 10.  Solve it in a
   similar manner to rename.  No need to worry about bugs not present
   on Solaris, since all other systems either lack renameat or honor
   trailing slash correctly.  */

int
rpl_renameat (int fd1, char const *src, int fd2, char const *dst)
{
  size_t src_len = strlen (src);
  size_t dst_len = strlen (dst);
  char *src_temp = (char *) src;
  char *dst_temp = (char *) dst;
  bool src_slash;
  bool dst_slash;
  int ret_val = -1;
  int rename_errno = ENOTDIR;
  struct stat src_st;
  struct stat dst_st;

  /* Let strace see any ENOENT failure.  */
  if (!src_len || !dst_len)
    return renameat (fd1, src, fd2, dst);

  src_slash = src[src_len - 1] == '/';
  dst_slash = dst[dst_len - 1] == '/';
  if (!src_slash && !dst_slash)
    return renameat (fd1, src, fd2, dst);

  /* Presence of a trailing slash requires directory semantics.  If
     the source does not exist, or if the destination cannot be turned
     into a directory, give up now.  Otherwise, strip trailing slashes
     before calling rename.  */
  if (lstatat (fd1, src, &src_st))
    return -1;
  if (lstatat (fd2, dst, &dst_st))
    {
      if (errno != ENOENT || !S_ISDIR (src_st.st_mode))
        return -1;
    }
  else if (!S_ISDIR (dst_st.st_mode))
    {
      errno = ENOTDIR;
      return -1;
    }
  else if (!S_ISDIR (src_st.st_mode))
    {
      errno = EISDIR;
      return -1;
    }

# if RENAME_TRAILING_SLASH_SOURCE_BUG
  /* See the lengthy comment in rename.c why Solaris 9 is forced to
     GNU behavior, while Solaris 10 is left with POSIX behavior,
     regarding symlinks with trailing slash.  */
  if (src_slash)
    {
      src_temp = strdup (src);
      if (!src_temp)
        {
          /* Rather than rely on strdup-posix, we set errno ourselves.  */
          rename_errno = ENOMEM;
          goto out;
        }
      strip_trailing_slashes (src_temp);
      if (lstatat (fd1, src_temp, &src_st))
        {
          rename_errno = errno;
          goto out;
        }
      if (S_ISLNK (src_st.st_mode))
        goto out;
    }
  if (dst_slash)
    {
      dst_temp = strdup (dst);
      if (!dst_temp)
        {
          rename_errno = ENOMEM;
          goto out;
        }
      strip_trailing_slashes (dst_temp);
      if (lstatat (fd2, dst_temp, &dst_st))
        {
          if (errno != ENOENT)
            {
              rename_errno = errno;
              goto out;
            }
        }
      else if (S_ISLNK (dst_st.st_mode))
        goto out;
    }
# endif /* RENAME_TRAILING_SLASH_SOURCE_BUG */

  ret_val = renameat (fd1, src_temp, fd2, dst_temp);
  rename_errno = errno;
 out:
  if (src_temp != src)
    free (src_temp);
  if (dst_temp != dst)
    free (dst_temp);
  errno = rename_errno;
  return ret_val;
}

#else /* !HAVE_RENAMEAT */

# include "openat-priv.h"

/* Rename FILE1, in the directory open on descriptor FD1, to FILE2, in
   the directory open on descriptor FD2.  If possible, do it without
   changing the working directory.  Otherwise, resort to using
   save_cwd/fchdir, then rename/restore_cwd.  If either the save_cwd or
   the restore_cwd fails, then give a diagnostic and exit nonzero.  */

int
renameat (int fd1, char const *file1, int fd2, char const *file2)
{
  return at_func2 (fd1, file1, fd2, file2, rename);
}

#endif /* !HAVE_RENAMEAT */
