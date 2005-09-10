--- coders/dot.c.orig	2005-07-20 20:47:39.000000000 -0600
+++ coders/dot.c	2005-09-07 15:10:46.000000000 -0600
@@ -143,19 +143,19 @@
     read_info->filename,image_info->filename);
   argv=StringToArgv(command,&argc);
   gvc=gvContext();
-  parse_args(gvc,argc,argv);
+  gvParseArgs(gvc,argc,argv);
   while ((graph=next_input_graph()) != (graph_t *) NULL)
   {
     if (previous_graph != (graph_t *) NULL)
       {
-        gvlayout_cleanup(gvc,previous_graph);
+        gvFreeLayout(gvc,previous_graph);
         agclose(previous_graph);
       }
-    gvlayout_layout(gvc,graph);
-    emit_jobs(gvc,graph);
+    gvLayoutJobs(gvc,graph);
+    gvRenderJobs(gvc,graph);
     previous_graph=graph;
   }
-  gvCleanup(gvc);
+  gvFreeContext(gvc);
   for (i=0; i < argc; i++)
     argv[i]=(char *) RelinquishMagickMemory(argv[i]);
   argv=(char **) RelinquishMagickMemory(argv);
