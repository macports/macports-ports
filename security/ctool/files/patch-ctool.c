--- ctool.c.orig	2004-04-03 00:39:45.000000000 +1000
+++ ctool.c	2010-11-27 06:22:17.000000000 +1100
@@ -26,12 +26,14 @@
 
 #include <stdlib.h>
 #include <stdio.h>
+#include <string.h>
 #include <unistd.h>
 #include <fcntl.h>
 
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/errno.h>
+#include <sys/mman.h>
 #include <sys/time.h>
 #include <sys/param.h>
 
@@ -252,12 +254,10 @@ void process_file( const char *file_path
     struct load_command command;
     struct stat stats;
 
-    kern_return_t result;
-
     int fd;
     int length;
 
-    unsigned long size;
+    off_t size;
     unsigned long index;
     unsigned long remaining;
     unsigned long file_pos;
@@ -308,9 +308,13 @@ void process_file( const char *file_path
         fprintf( stderr, "...skipping zero length file.\n" );
         goto exit_gracefully;
     }
+    if( size > SIZE_T_MAX )
+    {
+        size = SIZE_T_MAX;
+    }
 
-    if( ( result = map_fd( (int)fd, (vm_offset_t)0, (vm_offset_t *)&addr_base,
-                           (boolean_t)TRUE, (vm_size_t)size) ) != KERN_SUCCESS )
+    if( ( addr_base = mmap( NULL, (size_t)size, PROT_READ, MAP_FILE|MAP_PRIVATE,
+                           (int)fd, (off_t)0) ) == MAP_FAILED )
     {
         fprintf( stderr, "unable to map file: %s\n", path );
         goto exit_gracefully;
@@ -405,13 +409,13 @@ print_hash:
 
     if( debug )
     {
-        int bytes_excluded = ( size - bytes_read );
+        size_t bytes_excluded = ( size - bytes_read );
 
-        fprintf( stdout, "file size: (%d) bytes.\n", size );
+        fprintf( stdout, "file size: (%llu) bytes.\n", size );
 
         if( has_prebinding )
         {
-            fprintf( stdout, "excluded a total of %d bytes from checksum.\n",
+            fprintf( stdout, "excluded a total of %lu bytes from checksum.\n",
                      bytes_excluded );
         }
     }
@@ -517,7 +521,7 @@ void checksum_section( const char *segme
 
             if( debug )
             {
-             fprintf( stdout, "...read section %s,%s (offset=%lu,size=%lu).\n",
+             fprintf( stdout, "...read section %s,%s (offset=%u,size=%u).\n",
                          segment_name, section_name, section.offset,
                          section.size );
             }
@@ -687,14 +691,14 @@ void print_stats( const char *file_path,
         struct group *grp;
 
         fprintf( stdout, "\nstats for (%s):\n\n", file_path );
-        fprintf( stdout, "      device: %lu\n", stats->st_dev );
-        fprintf( stdout, "       inode: %lu\n", stats->st_ino );
+        fprintf( stdout, "      device: %u\n", stats->st_dev );
+        fprintf( stdout, "       inode: %llu\n", (uint64_t)stats->st_ino );
 
         /* file permissisons string.*/
 
         get_file_attribute_string( buffer, sizeof(buffer), stats->st_mode );
-        fprintf( stdout, "        mode: %s (%lu)\n", buffer, stats->st_mode );
-        fprintf( stdout, "       links: %lu\n", stats->st_nlink );
+        fprintf( stdout, "        mode: %s (%hu)\n", buffer, stats->st_mode );
+        fprintf( stdout, "       links: %hu\n", stats->st_nlink );
 
         /* display user and group names. */
 
@@ -714,10 +718,10 @@ void print_stats( const char *file_path,
             safe_strlcpy( group, grp->gr_name, sizeof( group ) );
         }
 
-        fprintf( stdout, "         uid: %lu %s\n", stats->st_uid, name );
-        fprintf( stdout, "         gid: %lu %s\n", stats->st_gid, group );
+        fprintf( stdout, "         uid: %u %s\n", stats->st_uid, name );
+        fprintf( stdout, "         gid: %u %s\n", stats->st_gid, group );
 
-        fprintf( stdout, "        rdev: %lu\n", stats->st_rdev );
+        fprintf( stdout, "        rdev: %u\n", stats->st_rdev );
 
        /* mtime. */
 
@@ -748,9 +752,9 @@ void print_stats( const char *file_path,
 
         fprintf( stdout, "       bytes: %llu\n", stats->st_size );
         fprintf( stdout, "      blocks: %llu\n", stats->st_blocks );
-        fprintf( stdout, "  block size: %lu\n", stats->st_blksize );
-        fprintf( stdout, "       flags: %lu\n", stats->st_flags );
-        fprintf( stdout, "  gen number: %lu\n", stats->st_gen );
+        fprintf( stdout, "  block size: %u\n", stats->st_blksize );
+        fprintf( stdout, "       flags: %lu\n", (unsigned long)stats->st_flags );
+        fprintf( stdout, "  gen number: %lu\n", (unsigned long)stats->st_gen );
 
         fprintf( stdout, "\n" );
     }
@@ -779,7 +783,7 @@ void verify_with_knowngoods( const char 
         safe_strlcat( kg_get_url, file_hash, sizeof( kg_get_url ) );
 
         curl_easy_setopt( curl, CURLOPT_URL, kg_get_url );
-        curl_easy_setopt( curl, CURLOPT_NOPROGRESS );
+        curl_easy_setopt( curl, CURLOPT_NOPROGRESS, 1 );
 
         response = curl_easy_perform( curl );
         curl_easy_cleanup( curl );
