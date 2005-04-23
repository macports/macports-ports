--- src/parser.c.orig	Thu Mar 27 18:09:49 2003
+++ src/parser.c	Thu Sep  4 22:11:43 2003
@@ -148,7 +148,7 @@
 	_verbosity_level = 0;
 
 	/* option recognition loop */
-	while ((c = getopt_long(argc, argv, "46ehlnp:q:s:uvw:x",
+	while ((c = getopt_long(argc, argv, "46e:hlnp:q:s:uvw:x",
 	                        long_options, &option_index)) >= 0)
 	{
  		switch (c) {
