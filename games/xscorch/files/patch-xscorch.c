--- xscorch.c	Mon Jun 17 22:29:47 2002
+++ xscorch.c	Sun Jul  7 16:10:36 2002
@@ -70,7 +70,6 @@
    sigemptyset(&sigset);
    sigaddset(&sigset, SIGPIPE);
    sa.sa_handler = sc_signal_handler;
-   sa.sa_sigaction = NULL;
    sa.sa_mask = sigset;
    sa.sa_flags = 0;
    sigaction(SIGPIPE, &sa, NULL);
