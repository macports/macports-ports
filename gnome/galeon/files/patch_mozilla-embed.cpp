--- mozilla/mozilla-embed.cpp.org	Wed Oct 13 18:09:43 2004
+++ mozilla/mozilla-embed.cpp	Wed Oct 13 18:09:43 2004
@@ -1397,7 +1397,9 @@
 	 *
 	 * See http://bugzilla.mozilla.org/show_bug.cgi?id=246392
 	 */
-	wrapper->ReloadPage (GTK_MOZ_EMBED_FLAG_RELOADCHARSETCHANGE);
+	/* wrapper->ReloadPage (GTK_MOZ_EMBED_FLAG_RELOADCHARSETCHANGE); */
+	gtk_moz_embed_reload (GTK_MOZ_EMBED (embed),
+                              GTK_MOZ_EMBED_FLAG_RELOADCHARSETCHANGE);
 #endif
  
 	return G_OK;
