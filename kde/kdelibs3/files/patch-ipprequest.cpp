--- kdelibs-3.5.1/kdeprint/cups/ipprequest.cpp~	2005-10-11 00:06:30.000000000 +0900
+++ kdelibs-3.5.1/kdeprint/cups/ipprequest.cpp	2006-08-17 17:38:42.000000000 +0900
@@ -511,6 +511,10 @@
 	cupsFreeOptions(n, options);
 
 	// find an remove that annoying "document-format" attribute
+#if CUPS_VERSION_MAJOR == 1 && CUPS_VERSION_MINOR >= 2
+	ipp_attribute_t *attr = ippFindAttribute(request_, "document-format", IPP_TAG_NAME);
+	ippDeleteAttribute(request_, attr);
+#else
 	ipp_attribute_t	*attr = request_->attrs;
 	while (attr)
 	{
@@ -523,4 +527,5 @@
 		}
 		attr = attr->next;
 	}
+#endif
 }
