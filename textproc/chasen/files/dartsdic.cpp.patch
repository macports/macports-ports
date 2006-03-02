--- lib/dartsdic.cpp.orig	Thu Jul 31 01:06:57 2003
+++ lib/dartsdic.cpp	Wed Jan 25 09:30:23 2006
@@ -68,7 +68,7 @@
 
     da = (darts_t*)cha_malloc(sizeof(darts_t));
     da->da_mmap = cha_mmap_file(daname);
-    darts->setArray(cha_mmap_map(da->da_mmap));
+    darts->set_array(cha_mmap_map(da->da_mmap));
     da->da = darts;
     da->lex_mmap = cha_mmap_file(lexname);
     da->dat_mmap = cha_mmap_file(datname);
@@ -177,7 +177,7 @@
 	    lex_indices.push_back(i->second);
 	}
 	lens[size] = key.size();
-	(const char*)keys[size] = key.data();
+	keys[size] = (char*) key.data();
 	vals[size] = redump_lex(lens[size], lex_indices, tmpfile, lexfile);
 	if (vals[size] < 0) {
 	    std::cerr << "Unexpected error at " << key << std::endl;
