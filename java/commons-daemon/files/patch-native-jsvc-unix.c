--- src/native/unix/native/jsvc-unix.c.orig	Mon Feb  9 07:55:21 2004
+++ src/native/unix/native/jsvc-unix.c	Thu Oct 14 14:28:07 2004
@@ -46,7 +46,6 @@
             } else {
                 stopping=true;
             }
-            if (handler_trm!=NULL) (*handler_trm)(sig);
             break;
         }
 
@@ -57,7 +56,6 @@
             } else {
                 stopping=true;
             }
-            if (handler_int!=NULL) (*handler_int)(sig);
             break;
         }
 
@@ -69,7 +67,6 @@
                 stopping=true;
                 doreload=true;
             }
-            if (handler_hup!=NULL) (*handler_hup)(sig);
             break;
         }
 
@@ -247,18 +244,9 @@
  */
 
 static int child(arg_data *args, home_data *data, uid_t uid, gid_t gid) {
-    FILE *pidf=fopen(args->pidf,"w");
     pid_t pidn=getpid();
     int ret=0;
 
-    /* Write the our pid in the pid file */
-    if (pidf!=NULL) {
-        fprintf(pidf,"%d\n",(int)pidn);
-        fclose(pidf);
-    } else {
-        log_error("Cannot open PID file %s, PID is %d",args->pidf,pidn);
-    }
-
     /* create a new process group to prevent kill 0 killing the monitor process */
 #if defined(OS_FREEBSD) || defined(OS_DARWIN)
     setpgid(0,0);
@@ -325,7 +313,7 @@
 
     /* Destroy the Java VM */
     if (JVM_destroy(ret)!=true) return(7);
-
+    
     return(ret);
 }
 
@@ -384,7 +372,8 @@
     pid_t pid=0;
     uid_t uid=0;
     gid_t gid=0;
-
+	FILE *pidf=NULL;
+	
     /* Parse command line arguments */
     args=arguments(argc,argv);
     if (args==NULL) return(1);
@@ -470,8 +459,21 @@
         signal(SIGHUP,controller);
         signal(SIGTERM,controller);
         signal(SIGINT,controller);
+        
+		/* Write the child's pid to the pid file */
+		pidf=fopen(args->pidf,"w");
+		if (pidf!=NULL) {
+			fprintf(pidf,"%d\n",(int)pid);
+			fclose(pidf);
+		} else {
+			log_error("Cannot open PID file %s, PID is %d",args->pidf,pid);
+		}
 
         while (waitpid(pid,&status,0)!=pid);
+        
+        /* Delete the pid file */
+        if (pidf != NULL)
+        	unlink(args->pidf);
 
         /* The child must have exited cleanly */
         if (WIFEXITED(status)) {
