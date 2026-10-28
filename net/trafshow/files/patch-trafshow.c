--- trafshow.c.org	2006-03-14 10:58:07.000000000 +0300
+++ trafshow.c	2006-05-15 20:50:43.000000000 +0400
@@ -862,7 +862,7 @@
  -n         Don't convert numeric values to names\n\
  -b         To place a backflow near to the main stream\n\
  -a len     To aggregate IP addresses using the prefix length\n\
- -c conf    Color config file instead of default /etc/trafshow\n\
+ -c conf    Color config file instead of default %%PREFIX%%/etc/trafshow\n\
  -i ifname  Network interface name; all by default\n\
  -s str     To search & follow for string in the list show\n\
  -u port    UDP port number to listen for Cisco Netflow; default %d\n\
