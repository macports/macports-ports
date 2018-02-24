diff --git a/include/osmocom/core/stats.h b/include/osmocom/core/stats.h
index e4d46ba..6546580 100644
--- a/include/osmocom/core/stats.h
+++ b/include/osmocom/core/stats.h
@@ -24,12 +24,6 @@
  *  @{
  *  \file stats.h */
 
-/* a bit of a crude way to disable building/using this on (bare iron)
- * embedded systems.  We cannot use the autoconf-defined HAVE_... macros
- * here, as that only works at library compile time, not at application
- * compile time */
-#ifdef unix
-
 #include <sys/socket.h>
 #include <arpa/inet.h>
 
@@ -141,5 +135,4 @@ int osmo_stats_reporter_send_buffer(struct osmo_stats_reporter *srep);
 int osmo_stats_reporter_udp_open(struct osmo_stats_reporter *srep);
 int osmo_stats_reporter_udp_close(struct osmo_stats_reporter *srep);
 
-#endif /* unix */
 /*! @} */
