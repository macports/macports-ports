$NetBSD: patch-common_msg.c,v 1.2 2017/04/04 07:53:23 fhajny Exp $

--- common/msg.c.orig	2017-04-03 15:17:07.396452540 +0000
+++ common/msg.c
@@ -715,7 +715,7 @@ msg_open(SCR *sp, char *file)
 	DB *db;
 	DBT data, key;
 	db_recno_t msgno;
-	char *p, *t, buf[MAXPATHLEN];
+	char *p, *p2, *t, buf[MAXPATHLEN];
 
 	if ((p = strrchr(file, '/')) != NULL && p[1] == '\0' &&
 	    (((t = getenv("LC_MESSAGES")) != NULL && t[0] != '\0') ||
@@ -724,16 +724,15 @@ msg_open(SCR *sp, char *file)
 		p = buf;
 	} else
 		p = file;
-	if ((sp->db_error = db_create(&db, 0, 0)) != 0 ||
-	    (sp->db_error = db->set_re_source(db, p)) != 0 ||
-	    (sp->db_error = db_open(db, NULL, DB_RECNO, 0, 0)) != 0) {
-		if (first) {
-			first = 0;
-			return (1);
-		}
-		msgq_str(sp, M_DBERR, p, "%s");
-		return (1);
-	}
+
+	p2 = "%s";
+	if ((sp->db_error = db_create(&db, 0, 0)) == 0 &&
+	    (sp->db_error = db->set_re_source(db, p)) == 0) {
+		db->set_errcall(db, 0);
+	    	if ((sp->db_error = db_open(db, NULL, DB_RECNO, 0, 0)) != 0)
+			goto err;
+	} else
+		goto err;
 
 	/*
 	 * Test record 1 for the magic string.  The msgq call is here so
@@ -749,13 +748,8 @@ msg_open(SCR *sp, char *file)
 	    data.size != sizeof(VMC) - 1 ||
 	    memcmp(data.data, VMC, sizeof(VMC) - 1)) {
 		(void)db->close(db, DB_NOSYNC);
-		if (first) {
-			first = 0;
-			return (1);
-		}
-		msgq_str(sp, M_DBERR, p,
-		    "030|The file %s is not a message catalog");
-		return (1);
+		p2 = "030|The file %s is not a message catalog";
+		goto err;
 	}
 	first = 0;
 
@@ -763,6 +757,14 @@ msg_open(SCR *sp, char *file)
 		(void)sp->gp->msg->close(sp->gp->msg, DB_NOSYNC);
 	sp->gp->msg = db;
 	return (0);
+
+err:
+	if (first) {
+		first = 0;
+		return (1);
+	}
+	msgq_str(sp, M_DBERR, p, p2);
+	return (1);
 }
 
 /*
