--- dd_rescue.c	Sun Aug 29 00:57:11 2004
+++ ../../work.new/dd_rescue/dd_rescue.c	Sat Oct 23 17:09:00 2004
@@ -551,7 +551,9 @@
 	fprintf(stderr, "         -l logfdile name of a file to log errors and summary to (def=\"\");\n");
 	fprintf(stderr, "         -r         reverse direction copy (def=forward);\n");
 	fprintf(stderr, "         -t         truncate output file (def=no);\n");
+#ifdef O_DIRECT
 	fprintf(stderr, "         -d/D       use O_DIRECT for input/output (def=no);\n");
+#endif
 	fprintf(stderr, "         -w         abort on Write errors (def=no);\n");
 	fprintf(stderr, "         -a         spArse file writing (def=no),\n");
 	fprintf(stderr, "         -A         Always write blocks, zeroed if err (def=no);\n");
@@ -620,8 +622,10 @@
 			case 't': dotrunc = O_TRUNC; break;
 			case 'i': interact = 1; force = 0; break;
 			case 'f': interact = 0; force = 1; break;
+#ifdef O_DIRECT
 			case 'd': o_dir_in  = O_DIRECT; break;
 			case 'D': o_dir_out = O_DIRECT; break;
+#endif
 			case 'p': pres = 1; break;
 			case 'a': sparse = 1; nosparse = 0; break;
 			case 'A': nosparse = 1; sparse = 0; break;
