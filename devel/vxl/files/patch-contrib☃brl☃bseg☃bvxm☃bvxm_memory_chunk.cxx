--- contrib/brl/bseg/bvxm/bvxm_memory_chunk.cxx	2008-11-29 04:55:36.000000000 -0800
+++ contrib/brl/bseg/bvxm/bvxm_memory_chunk.cxx	2008-11-29 04:55:45.000000000 -0800
@@ -48,6 +48,3 @@
     data_ = new char[(unsigned)n];
   size_ = n;
 }
-
-VBL_SMART_PTR_INSTANTIATE(bvxm_memory_chunk);
-
