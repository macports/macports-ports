Fix segmentation fault with jpeg-7 and above where dinfo.do_fancy_upsampling isn't set by default to FALSE anymore.

Patch by: Salah Coronya

http://bugs.gentoo.org/show_bug.cgi?id=293919

--- lavtools/jpegutils.c
+++ lavtools/jpegutils.c
@@ -502,6 +502,7 @@
 
    jpeg_read_header (&dinfo, TRUE);
    dinfo.raw_data_out = TRUE;
+   dinfo.do_fancy_upsampling = FALSE;
    dinfo.out_color_space = JCS_YCbCr;
    dinfo.dct_method = JDCT_IFAST;
    guarantee_huff_tables(&dinfo);
@@ -599,6 +600,7 @@
       if (field > 0) {
          jpeg_read_header (&dinfo, TRUE);
          dinfo.raw_data_out = TRUE;
+         dinfo.do_fancy_upsampling = FALSE;
          dinfo.out_color_space = JCS_YCbCr;
          dinfo.dct_method = JDCT_IFAST;
          jpeg_start_decompress (&dinfo);
