--- libtest/ping.c.orig	Wed Dec 22 10:00:09 2004
+++ libtest/ping.c	Sun Jan 30 18:15:14 2005
@@ -166,9 +166,10 @@
 	icmp_send->icmp_cksum = in_cksum((u_short *)icmp_send,
 		SEND_PACKET_SIZE );
 
-	if (( send_wrote = sendto( nefu_raw_socket, (char *)icmp_send,
+	if ((( send_wrote = sendto( nefu_raw_socket, (char *)icmp_send,
 		SEND_PACKET_SIZE, 0, (struct sockaddr *)&t->t_sin,
-		sizeof( struct sockaddr_in ))) < 0 ) {
+		sizeof( struct sockaddr_in ))) < 0 ) &&
+		( errno != EHOSTDOWN )) {
 	    report_printf( r, "sendto: %m" );
 	    return( T_MAYBE_DOWN );
 	}
