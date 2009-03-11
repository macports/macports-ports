Index: lib/lzmaxar.c
===================================================================
--- lib/lzmaxar.c	(revision 224)
+++ lib/lzmaxar.c	(arbetskopia)
@@ -76,11 +76,12 @@
 #else
 	lzma_options_lzma options2;
 #endif
-	lzma_allocator allocator;
 #if LZMA_VERSION < 40420010U
 	lzma_memory_limitter *limit;
-#else
+	lzma_allocator allocator;
+#elif LZMA_VERSION < 49990060U
 	lzma_memlimit *limit;
+	lzma_allocator allocator;
 #endif
 };
 
@@ -133,15 +134,23 @@
 		else
 			return 0;
 		
+	#if LZMA_VERSION < 49990070U
 		lzma_init_decoder();
+	#endif
 	#ifdef LZMA_STREAM_INIT_VAR
 		LZMA_CONTEXT(context)->lzma = LZMA_STREAM_INIT_VAR;
 	#endif
 	#if LZMA_VERSION < 49990050U
 		r = lzma_auto_decoder(&LZMA_CONTEXT(context)->lzma, NULL, NULL);
+	#elif LZMA_VERSION < 49990060U
+		r = lzma_auto_decoder(&LZMA_CONTEXT(context)->lzma,
+		        lzma_easy_memory_usage(preset_level), 0);
+	#elif LZMA_VERSION < 49990070U
+		r = lzma_auto_decoder(&LZMA_CONTEXT(context)->lzma,
+		        lzma_easy_encoder_memusage(preset_level, 0), 0);
 	#else
 		r = lzma_auto_decoder(&LZMA_CONTEXT(context)->lzma,
-		        lzma_easy_memory_usage(preset_level), 0);
+		        lzma_easy_encoder_memusage(preset_level), 0);
 	#endif
 		if( (r != LZMA_OK) ) {
 			xar_err_new(x);
@@ -217,7 +226,7 @@
 		lzma_end(&LZMA_CONTEXT(context)->lzma);		
 #if LZMA_VERSION < 40420010U
 		lzma_memory_limitter_end(LZMA_CONTEXT(context)->limit, 1);
-#else
+#elif LZMA_VERSION < 49990060U
 		lzma_memlimit_end(LZMA_CONTEXT(context)->limit, 1);
 #endif
 
@@ -273,7 +282,9 @@
 			}
 		}
 		
+#if LZMA_VERSION < 49990070U
 		lzma_init_encoder();
+#endif
 #if LZMA_VERSION < 49990050U
 		LZMA_CONTEXT(context)->options.check = LZMA_CHECK_CRC64;
 		LZMA_CONTEXT(context)->options.has_crc32 = 1; /* true */
@@ -298,13 +309,17 @@
 		LZMA_CONTEXT(context)->limit = lzma_memory_limitter_create(memory_limit);
 		LZMA_CONTEXT(context)->allocator.alloc = (void*) lzma_memory_alloc;
 		LZMA_CONTEXT(context)->allocator.free = (void*) lzma_memory_free;
-#else
+		LZMA_CONTEXT(context)->allocator.opaque = LZMA_CONTEXT(context)->limit;
+		LZMA_CONTEXT(context)->lzma.allocator = &LZMA_CONTEXT(context)->allocator;
+#elif LZMA_VERSION < 49990060U
 		LZMA_CONTEXT(context)->limit = lzma_memlimit_create(memory_limit);
 		LZMA_CONTEXT(context)->allocator.alloc = (void*) lzma_memlimit_alloc;
 		LZMA_CONTEXT(context)->allocator.free = (void*) lzma_memlimit_free;
-#endif
 		LZMA_CONTEXT(context)->allocator.opaque = LZMA_CONTEXT(context)->limit;
 		LZMA_CONTEXT(context)->lzma.allocator = &LZMA_CONTEXT(context)->allocator;
+#else
+		lzma_memlimit_set(&LZMA_CONTEXT(context)->lzma, memory_limit);
+#endif
 #if LZMA_VERSION < 49990050U
 		if (alone){
 		LZMA_CONTEXT(context)->options2.uncompressed_size = *inlen;
@@ -326,6 +341,15 @@
 		else
 		r = lzma_stream_encoder(&LZMA_CONTEXT(context)->lzma,
 		                        LZMA_CONTEXT(context)->filters, LZMA_CONTEXT(context)->check);
+#elif LZMA_VERSION < 49990070U
+		if (alone){
+		lzma_lzma_preset(&(LZMA_CONTEXT(context)->options2), level);
+		r = lzma_alone_encoder(&LZMA_CONTEXT(context)->lzma,
+		                       &(LZMA_CONTEXT(context)->options2));
+		}
+		else
+		r = lzma_easy_encoder(&LZMA_CONTEXT(context)->lzma,
+		                      level, 0, LZMA_CHECK_CRC64);
 #else
 		if (alone){
 		lzma_lzma_preset(&(LZMA_CONTEXT(context)->options2), level);
@@ -334,7 +358,7 @@
 		}
 		else
 		r = lzma_easy_encoder(&LZMA_CONTEXT(context)->lzma,
-		                      (lzma_easy_level) level);
+		                      level, LZMA_CHECK_CRC64);
 #endif
 		if( (r != LZMA_OK) ) {
 			xar_err_new(x);
