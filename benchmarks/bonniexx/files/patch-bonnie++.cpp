--- bonnie++.cpp	2016-12-12 21:37:51.000000000 -0500
+++ bonnie++.cpp	2017-01-14 19:35:45.000000000 -0500
@@ -294,11 +294,7 @@
       {
         char *sbuf = _strdup(optarg);
         char *size = strtok(sbuf, ":");
-#ifdef _LARGEFILE64_SOURCE
         file_size = size_from_str(size, "gt");
-#else
-        file_size = size_from_str(size, "g");
-#endif
         size = strtok(NULL, "");
         if(size)
         {
@@ -384,15 +380,6 @@
     if(file_size % 1024 > 512)
       file_size = file_size + 1024 - (file_size % 1024);
   }
-#ifndef _LARGEFILE64_SOURCE
-  if(file_size == 2048)
-    file_size = 2047;
-  if(file_size > 2048)
-  {
-    fprintf(stderr, "Large File Support not present, can't do %dM.\n", file_size);
-    usage();
-  }
-#endif
   globals.byte_io_size = min(file_size, globals.byte_io_size);
   globals.byte_io_size = max(0, globals.byte_io_size);
 
@@ -465,14 +452,6 @@
      && (directory_max_size < directory_min_size || directory_max_size < 0
      || directory_min_size < 0) )
     usage();
-#ifndef _LARGEFILE64_SOURCE
-  if(file_size > (1 << (31 - 20 + globals.io_chunk_bits)) )
-  {
-    fprintf(stderr
-   , "The small chunk size and large IO size make this test impossible in 32bit.\n");
-    usage();
-  }
-#endif
   if(file_size && globals.ram && (file_size * concurrency) < (globals.ram * 2) )
   {
     fprintf(stderr
