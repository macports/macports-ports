--- libplot/n_write.c.orig	2000-06-15 23:42:13.000000000 -0600
+++ libplot/n_write.c	2005-06-13 22:55:50.000000000 -0600
@@ -208,7 +208,7 @@
 		  linebuf[pos++] = '0';
 		if (pos >= MAX_PBM_PIXELS_PER_LINE || i == (width - 1))
 		  {
-		    stream->write (linebuf, pos);
+		    stream->write ((const char *)linebuf, pos);
 		    stream->put ('\n');
 
 		    pos = 0;
@@ -253,7 +253,7 @@
 		  rowbuf[bytecount++] = outbyte;
 		}
 	      /* emit row of bytes */
-	      stream->write (rowbuf, bytecount);
+	      stream->write ((const char *)rowbuf, bytecount);
 	    }
 
 	  free (rowbuf);
@@ -366,7 +366,7 @@
 		num_pixels++;
 		if (num_pixels >= MAX_PGM_PIXELS_PER_LINE || i == (width - 1))
 		  {
-		    stream->write (linebuf, pos);
+		    stream->write ((const char *)linebuf, pos);
 		    stream->put ('\n');
 
 		    num_pixels = 0;
@@ -392,7 +392,7 @@
 	    {
 	      for (i = 0; i < width; i++)
 		rowbuf[i] = pixmap[j][i].u.rgb[0];
-	      stream->write (rowbuf, width);
+	      stream->write ((const char *)rowbuf, width);
 	    }
 	  free (rowbuf);
 	}
@@ -514,7 +514,7 @@
 		num_pixels++;
 		if (num_pixels >= MAX_PPM_PIXELS_PER_LINE || i == (width - 1))
 		  {
-		    stream->write (linebuf, pos);
+		    stream->write ((const char *)linebuf, pos);
 		    stream->put ('\n');
 
 		    num_pixels = 0;
@@ -542,7 +542,7 @@
 	      for (i = 0; i < width; i++)
 		for (component = 0; component < 3; component++)
 		  rowbuf[3 * i + component] = pixmap[j][i].u.rgb[component];
-	      stream->write (rowbuf, 3 * width);
+	      stream->write ((const char *)rowbuf, 3 * width);
 	    }
 	  free (rowbuf);
 	}
