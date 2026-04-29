--- zcav_io.cpp.orig	2009-08-24 07:36:02.677798155 +0000
+++ zcav_io.cpp	2009-08-24 07:36:40.688614055 +0000
@@ -83,7 +83,6 @@
   for(int loops = 0; !exiting && loops < max_loops; loops++)
   {
     int i = 0;
-#ifdef _LARGEFILE64_SOURCE
     if(start_offset)
     {
       OFF_TYPE real_offset = OFF_TYPE(start_offset) * OFF_TYPE(m_block_size) * OFF_TYPE(1<<20);
@@ -96,7 +95,6 @@
       i = start_offset;
     }
     else
-#endif
     if(lseek(m_fd, 0, SEEK_SET))
     {
       fprintf(stderr, "Can't lseek().\n");
@@ -224,14 +222,12 @@
 // Read/write a block of data
 double ZcavRead::access_data(int skip)
 {
-#ifdef _LARGEFILE64_SOURCE
   if(skip)
   {
     OFF_TYPE real_offset = OFF_TYPE(skip) * OFF_TYPE(m_block_size) * OFF_TYPE(1<<20);
     if(file_lseek(m_fd, real_offset, SEEK_CUR) == OFF_TYPE(-1))
       return -1.0;
   }
-#endif
 
   m_dur.start();
   for(int i = 0; i < m_block_size; i+= m_chunk_size)
