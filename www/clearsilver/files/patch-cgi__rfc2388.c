--- ./cgi/rfc2388.c.orig	2006-08-29 10:44:50.000000000 +0200
+++ ./cgi/rfc2388.c	2012-04-23 18:04:40.890511212 +0200
@@ -44,7 +44,7 @@
   l = q - p;
   *val = (char *) malloc (l+1);
   if (*val == NULL)
-    return nerr_raise (NERR_NOMEM, "Unable to allocate space for val");
+    return nerr_raise (NERR_NOMEM, "%s", "Unable to allocate space for val");
   memcpy (*val, p, l);
   (*val)[l] = '\0';
 
@@ -86,7 +86,7 @@
       {
 	*val = strdup ("");
 	if (*val == NULL) 
-	  return nerr_raise (NERR_NOMEM, "Unable to allocate value");
+	  return nerr_raise (NERR_NOMEM, "%s", "Unable to allocate value");
 	return STATUS_OK;
       }
     }
@@ -110,7 +110,7 @@
       {
 	r = (char *) malloc (al+1);
 	if (r == NULL) 
-	  return nerr_raise (NERR_NOMEM, "Unable to allocate value");
+	  return nerr_raise (NERR_NOMEM, "%s", "Unable to allocate value");
 	memcpy (r, v, al);
 	r[al] = '\0';
 	*val = r;
@@ -133,7 +133,7 @@
     cgi->buflen = 4096;
     cgi->buf = (char *) malloc (sizeof(char) * cgi->buflen);
     if (cgi->buf == NULL)
-      return nerr_raise (NERR_NOMEM, "Unable to allocate cgi buf");
+      return nerr_raise (NERR_NOMEM, "%s", "Unable to allocate cgi buf");
   }
   if (cgi->unget)
   {
@@ -171,7 +171,7 @@
   cgiwrap_read (cgi->buf + ofs, to_read, &(cgi->readlen));
   if (cgi->readlen < 0)
   {
-    return nerr_raise_errno (NERR_IO, "POST Read Error");
+    return nerr_raise_errno (NERR_IO, "%s", "POST Read Error");
   }
   if (cgi->readlen == 0)
   {
@@ -182,7 +182,7 @@
   if (cgi->upload_cb)
   {
     if (cgi->upload_cb (cgi, cgi->data_read, cgi->data_expected))
-      return nerr_raise (CGIUploadCancelled, "Upload Cancelled");
+      return nerr_raise (CGIUploadCancelled, "%s", "Upload Cancelled");
   }
   cgi->readlen += ofs;
   p = memchr (cgi->buf, '\n', cgi->readlen);
@@ -235,7 +235,7 @@
     if (line->len > 50*1024*1024)
     {
       string_clear(line);
-      return nerr_raise(NERR_ASSERT, "read_header_line exceeded 50MB");
+      return nerr_raise(NERR_ASSERT, "%s", "read_header_line exceeded 50MB");
     }
   }
   return nerr_pass (err);
@@ -399,7 +399,7 @@
 	    strcmp(tmp, "binary"))
 	{
 	  free(tmp);
-	  err = nerr_raise (NERR_ASSERT, "form-data encoding is not supported");
+	  err = nerr_raise (NERR_ASSERT, "%s", "form-data encoding is not supported");
 	  break;
 	}
 	free(tmp);
@@ -559,14 +559,14 @@
   l = hdf_get_int_value (cgi->hdf, "CGI.ContentLength", -1);
   ct_hdr = hdf_get_value (cgi->hdf, "CGI.ContentType", NULL);
   if (ct_hdr == NULL) 
-    return nerr_raise (NERR_ASSERT, "No content type header?");
+    return nerr_raise (NERR_ASSERT, "%s", "No content type header?");
 
   cgi->data_expected = l;
   cgi->data_read = 0;
   if (cgi->upload_cb)
   {
     if (cgi->upload_cb (cgi, cgi->data_read, cgi->data_expected))
-      return nerr_raise (CGIUploadCancelled, "Upload Cancelled");
+      return nerr_raise (CGIUploadCancelled, "%s", "Upload Cancelled");
   }
 
   err = _header_attr (ct_hdr, "boundary", &boundary);
