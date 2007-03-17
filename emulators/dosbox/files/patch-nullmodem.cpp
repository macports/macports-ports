--- src/hardware/serialport/nullmodem.cpp.bak	2007-03-18 00:28:32.000000000 +0100
+++ src/hardware/serialport/nullmodem.cpp	2007-03-18 00:29:18.000000000 +0100
@@ -99,7 +99,7 @@
 					// custom connect
 					Bit8u peernamebuf[16];
 					LOG_MSG("inheritance port: %d",sock);
-					clientsocket = new TCPClientSocket(sock);
+					clientsocket = new TCPClientSocket((TCPsocket)sock);
 					if(!clientsocket->isopen) {
 						LOG_MSG("Serial%d: Connection failed.",COMNUMBER);
 						delete clientsocket;
