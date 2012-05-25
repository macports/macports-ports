--- arpd.c.orig	2003-02-09 15:20:40.000000000 +1100
+++ arpd.c	2012-05-26 05:44:37.000000000 +1000
@@ -265,7 +265,7 @@ arpd_send(eth_t *eth, int op,
 	    spa->addr_ip, tha->addr_eth, tpa->addr_ip);
 	
 	if (op == ARP_OP_REQUEST) {
-		syslog(LOG_DEBUG, __FUNCTION__ ": who-has %s tell %s",
+		syslog(LOG_DEBUG, "%s: who-has %s tell %s", __FUNCTION__,
 		    addr_ntoa(tpa), addr_ntoa(spa));
 	} else if (op == ARP_OP_REPLY) {
 		syslog(LOG_INFO, "arp reply %s is-at %s",
@@ -282,7 +282,7 @@ arpd_lookup(struct addr *addr)
 	int error;
 
 	if (addr_cmp(addr, &arpd_ifent.intf_addr) == 0) {
-		syslog(LOG_DEBUG, __FUNCTION__ ": %s at %s",
+		syslog(LOG_DEBUG, "%s: %s at %s", __FUNCTION__,
 		    addr_ntoa(addr), addr_ntoa(&arpd_ifent.intf_link_addr));
 		return (0);
 	}
@@ -291,10 +291,10 @@ arpd_lookup(struct addr *addr)
 	error = arp_get(arpd_arp, &arpent);
 	
 	if (error == -1) {
-		syslog(LOG_DEBUG, __FUNCTION__ ": no entry for %s",
+		syslog(LOG_DEBUG, "%s: no entry for %s", __FUNCTION__,
 		    addr_ntoa(addr));
 	} else {
-		syslog(LOG_DEBUG, __FUNCTION__ ": %s at %s",
+		syslog(LOG_DEBUG, "%s: %s at %s", __FUNCTION__,
 		    addr_ntoa(addr), addr_ntoa(&arpent.arp_ha));
 	}
 	return (error);
@@ -423,7 +423,7 @@ arpd_recv_cb(u_char *u, const struct pca
 		if ((req = SPLAY_FIND(tree, &arpd_reqs, &tmp)) != NULL) {
 			addr_pack(&src.arp_ha, ADDR_TYPE_ETH, ETH_ADDR_BITS,
 			    ethip->ar_sha, ETH_ADDR_LEN);
-			syslog(LOG_DEBUG, __FUNCTION__ ": %s at %s",
+			syslog(LOG_DEBUG, "%s: %s at %s", __FUNCTION__,
 			    addr_ntoa(&req->pa), addr_ntoa(&src.arp_ha));
 			
 			/* This address is claimed */
@@ -445,9 +445,6 @@ arpd_recv(int fd, short type, void *ev)
 void
 terminate_handler(int sig)
 {
-	extern int event_gotsig;
-
-	event_gotsig = 1;
 	arpd_sig = sig;
 }
 
@@ -464,7 +461,6 @@ int
 main(int argc, char *argv[])
 {
 	struct event recv_ev;
-	extern int (*event_sigcb)(void);
 	char *dev;
 	int c, debug;
 	FILE *fp;
@@ -524,7 +520,6 @@ main(int argc, char *argv[])
 		perror("signal");
 		return (-1);
 	}
-	event_sigcb = arpd_signal;
 	
 	event_dispatch();
 
