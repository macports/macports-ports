--- src/launcher.c.org	2005-05-19 07:55:25.000000000 +0200
+++ src/launcher.c	2005-05-19 07:58:04.000000000 +0200
@@ -1192,7 +1192,7 @@
 	}
 //	termios_flags.c_lflag |= 0;
 	termios_flags.c_cc[VMIN] = 0;
-	cfsetospeed(&termios_flags, B460800);
+	cfsetospeed(&termios_flags, 0xB460800);
 	tcsetattr(pty_master_fd, TCSANOW, &termios_flags);
 
 	launcher->priv->stderr_watch = 
