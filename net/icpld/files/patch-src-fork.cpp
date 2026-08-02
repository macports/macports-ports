--- src/fork.cpp	2006-04-26 22:00:51.000000000 +0200
+++ src/fork.cpp	2006-05-25 15:37:35.000000000 +0200
@@ -201,7 +201,7 @@
 */
 #ifdef DARWIN 
  command = "ping -i " + pint + " -n -c 1 " + ip + " |grep \"bytes from\"";
- command2 = "ping " + " -i " + pint + " -n -c 2 " + fbip + " |grep \"bytes from\"";
+ command2 = "ping -i " + pint + " -n -c 2 " + fbip + " |grep \"bytes from\"";
 #ifdef HAVE_IPV6
   command6 = PING6;
   command6 += " -i " +  pint + " -n -c 2 " + ip6 + " |grep \"bytes from\"";
