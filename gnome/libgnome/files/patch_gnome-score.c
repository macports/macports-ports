--- libgnome/gnome-score.c.org	Sun Nov 23 21:51:54 2003
+++ libgnome/gnome-score.c	Sun Nov 23 21:53:23 2003
@@ -230,13 +230,6 @@
    gchar *level;
    gchar *realname;
    gint retval;
-#ifdef HAVE_SETFSGID
-   gid_t gid;
-   
-   gid = getegid ();
-   setgid (getgid ());
-   setfsgid (gid);
-#endif
    realname = g_strdup (g_get_real_name ());
    if (strlen (realname) == 0)
      realname = g_strdup (g_get_user_name ());
