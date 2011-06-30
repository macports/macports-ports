--- libhttpd/src/select.h.orig	2011-06-30 17:41:19.000000000 +1000
+++ libhttpd/src/select.h	2011-06-30 17:37:20.000000000 +1000
@@ -38,7 +38,7 @@
 
 #ifdef __APPLE__
 #ifndef _SOCKLEN_T
-	typedef int socklen_t;
+	typedef unsigned int socklen_t;
 #define _SOCKLEN_T
 #endif
 #endif
@@ -68,6 +68,8 @@ struct Client {
 
 struct httpd;
 
+#define NULL_ITERATOR static_cast<ClientIterator>(0)
+
 class Clients {
 protected:
 	std::list<Client> clientList;
@@ -81,7 +83,7 @@ protected:
 			c++;
 		}
 	
-		return 0;
+		return NULL_ITERATOR;
 	}
 
 
@@ -154,7 +156,7 @@ public:	
 	
 	void erase( const int fDesc ) {
 		ClientIterator c;
-		if ((c = locateFDesc(fDesc)) != 0) {
+		if ((c = locateFDesc(fDesc)) != NULL_ITERATOR) {
 			clientList.erase(c);
 			close(fDesc);
 		}
@@ -162,14 +164,14 @@ public:	
 
 	void finish( const int fDesc ) {
 		ClientIterator c;
-		if ((c = locateFDesc(fDesc)) != 0) {
+		if ((c = locateFDesc(fDesc)) != NULL_ITERATOR) {
 			c->finished = true;
 		}
 	}
 
 	void address( const int fDesc, char address[HTTP_IP_ADDR_LEN] ) {
 		ClientIterator c;
-		if ((c = locateFDesc(fDesc)) != 0) {
+		if ((c = locateFDesc(fDesc)) != NULL_ITERATOR) {
 			strncpy(address, c->address, HTTP_IP_ADDR_LEN);
 		}
 	}
@@ -180,7 +182,7 @@ public:	
 
 	int readBuf(const int fDesc, char *destBuf, const uint len) {
 		ClientIterator c;
-		if ((c = locateFDesc(fDesc)) == 0) {
+		if ((c = locateFDesc(fDesc)) == NULL_ITERATOR) {
 			// printf("unknown client id %d\n", fDesc);
 			return 0;
 		}
@@ -192,7 +194,7 @@ public:	
 		
 	int readLine(const int fDesc, char *destBuf, const uint len) {
 		ClientIterator c;
-		if ((c = locateFDesc(fDesc)) == 0) {
+		if ((c = locateFDesc(fDesc)) == NULL_ITERATOR) {
 			// printf("unknown client id %d\n", fDesc);
 			return 0;
 		}
@@ -217,7 +219,7 @@ public:	
 	int handleWrite(int socket) {
 		int bytesWritten;
 		ClientIterator c;
-		if ((c = locateFDesc(socket)) == 0) {
+		if ((c = locateFDesc(socket)) == NULL_ITERATOR) {
 			// printf("unknown client id %d\n", socket);
 			return 2;
 		}
@@ -260,7 +262,7 @@ public:	
 			return 1;
 		} else {
 			ClientIterator c;
-			if ((c = locateFDesc(fDesc)) == 0) {
+			if ((c = locateFDesc(fDesc)) == NULL_ITERATOR) {
 				// printf("unknown client id %d\n", fDesc);
 				return 2;
 			}
@@ -304,7 +306,7 @@ public:	
 	
 	void doWrite(const int fDesc, const char* string, const uint len) {
 		ClientIterator c;
-		if ((c = locateFDesc(fDesc)) == 0) {
+		if ((c = locateFDesc(fDesc)) == NULL_ITERATOR) {
 			//printf("unknown client id %d\n", fDesc);
 			return;
 		}
@@ -318,7 +320,7 @@ public:	
 
 	void doWrite(const int fDesc, const char* string) {
 		ClientIterator c;
-		if ((c = locateFDesc(fDesc)) == 0) {
+		if ((c = locateFDesc(fDesc)) == NULL_ITERATOR) {
 			//printf("unknown client id %d\n", fDesc);
 			return;
 		}
@@ -351,7 +353,7 @@ public:	
 
 	void queueFile(const int socket, const int pendingFile ) {
 		ClientIterator c;
-		if ((c = locateFDesc(socket)) == 0) {
+		if ((c = locateFDesc(socket)) == NULL_ITERATOR) {
 			// printf("unknown client id %d\n", socket);
 			return;
 		}
@@ -360,7 +362,7 @@ public:	
 
 	void subscribe(const int fDesc) {
 		ClientIterator c;
-		if ((c = locateFDesc(fDesc)) == 0) {
+		if ((c = locateFDesc(fDesc)) == NULL_ITERATOR) {
 			//printf("unknown client id %d\n", fDesc);
 			return;
 		}
