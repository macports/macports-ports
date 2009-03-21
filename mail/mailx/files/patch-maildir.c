--- maildir.c.orig	2009-03-20 22:51:46.000000000 -0700
+++ maildir.c	2009-03-20 22:52:15.000000000 -0700
@@ -336,7 +336,7 @@
 
 	if ((fp = Fopen(m->m_maildir_file, "r")) == NULL) {
 		fprintf(stderr, "Cannot read \"%s/%s\" for message %d\n",
-				name, m->m_maildir_file, m - &message[0] + 1);
+				name, m->m_maildir_file, (int)(m - &message[0] + 1));
 		m->m_flag |= MHIDDEN;
 		return;
 	}
@@ -443,7 +443,7 @@
 				fprintf(stderr, "Cannot delete file \"%s/%s\" "
 						"for message %d.\n",
 						mailname, m->m_maildir_file,
-						m - &message[0] + 1);
+						(int)(m - &message[0] + 1));
 			else
 				gotcha++;
 		} else {
@@ -492,7 +492,7 @@
 				"message %d not touched.\n",
 				mailname, m->m_maildir_file,
 				mailname, new,
-				m - &message[0] + 1);
+				(int)(m - &message[0] + 1));
 		return;
 	}
 	if (unlink(m->m_maildir_file) < 0)
