--- compress.cc.orig	2005-04-03 23:03:47.000000000 -0400
+++ compress.cc	2005-04-03 23:06:28.000000000 -0400
@@ -183,14 +183,14 @@
 #if USE_BZIP2
 bool compress_bzip2(const unsigned char* in_data, unsigned in_size, unsigned char* out_data, unsigned& out_size, int blocksize, int workfactor)
 {
-	return BZ2_bzBuffToBuffCompress(out_data, &out_size, const_cast<unsigned char*>(in_data), in_size, blocksize, 0, workfactor) == BZ_OK;
+	return BZ2_bzBuffToBuffCompress((char *)out_data, &out_size, (char *)in_data, in_size, blocksize, 0, workfactor) == BZ_OK;
 }
 
 bool decompress_bzip2(const unsigned char* in_data, unsigned in_size, unsigned char* out_data, unsigned out_size)
 {
 	unsigned size = out_size;
 
-	if (BZ2_bzBuffToBuffDecompress(out_data, &size, const_cast<unsigned char*>(in_data), in_size, 0, 0)!=BZ_OK)
+	if (BZ2_bzBuffToBuffDecompress((char *)out_data, &size, (char *)in_data, in_size, 0, 0)!=BZ_OK)
 		return false;
 
 	if (size != out_size)
