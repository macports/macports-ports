--- libraries/network/Network/Socket.hsc.sav	2006-01-06 15:12:14.000000000 -0500
+++ libraries/network/Network/Socket.hsc	2006-01-06 18:08:48.000000000 -0500
@@ -357,15 +357,22 @@
    . shows port
 
 -- we can't write an instance of Storable for SockAddr, because the Storable
--- class can't easily handle alternatives.
+-- class can't easily handle alternatives. Also note that on Darwin, the
+-- sockaddr structure must be zeroed before use.
 
 #if defined(DOMAIN_SOCKET_SUPPORT)
 pokeSockAddr p (SockAddrUnix path) = do
+#if defined(darwin_TARGET_OS)
+	zeroMemory p (#const sizeof(struct sockaddr_un))
+#endif
 	(#poke struct sockaddr_un, sun_family) p ((#const AF_UNIX) :: CSaFamily)
 	let pathC = map castCharToCChar path
 	pokeArray0 0 ((#ptr struct sockaddr_un, sun_path) p) pathC
 #endif
 pokeSockAddr p (SockAddrInet (PortNum port) addr) = do
+#if defined(darwin_TARGET_OS)
+	zeroMemory p (#const sizeof(struct sockaddr_in))
+#endif
 	(#poke struct sockaddr_in, sin_family) p ((#const AF_INET) :: CSaFamily)
 	(#poke struct sockaddr_in, sin_port) p port
 	(#poke struct sockaddr_in, sin_addr) p addr	
@@ -383,6 +390,11 @@
 		port <- (#peek struct sockaddr_in, sin_port) p
 		return (SockAddrInet (PortNum port) addr)
 
+-- helper function used to zero a structure
+zeroMemory :: Ptr a -> CSize -> IO ()
+zeroMemory dest nbytes = memset dest 0 (fromIntegral nbytes)
+foreign import ccall unsafe "string.h" memset :: Ptr a -> CInt -> CSize -> IO ()
+
 -- size of struct sockaddr by family
 #if defined(DOMAIN_SOCKET_SUPPORT)
 sizeOfSockAddr_Family AF_UNIX = #const sizeof(struct sockaddr_un)
