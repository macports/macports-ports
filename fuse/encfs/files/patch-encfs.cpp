--- encfs/encfs.cpp.old	2007-03-14 19:34:49.000000000 -0400
+++ encfs/encfs.cpp	2007-03-14 19:35:34.000000000 -0400
@@ -609,7 +609,7 @@
 
 	rLog(Info, "setxattr %s", cyName.c_str());
 
-	res = ::setxattr( cyName.c_str(), name, value, size, flags );
+	res = ::setxattr( cyName.c_str(), name, value, size, flags, 0 );
 	if(res == -1)
 	    res = -errno;
     } catch( rlog::Error &err )
@@ -630,7 +630,7 @@
 
 	rLog(Info, "getxattr %s", cyName.c_str());
 
-	res = ::getxattr( cyName.c_str(), name, value, size );
+	res = ::getxattr( cyName.c_str(), name, value, size, 0, 0 );
 	if(res == -1)
 	    res = -errno;
     } catch( rlog::Error &err )
@@ -650,7 +650,7 @@
 
 	rLog(Info, "listxattr %s", cyName.c_str());
 
-	res = ::listxattr( cyName.c_str(), list, size );
+	res = ::listxattr( cyName.c_str(), list, size, 0 );
 	if(res == -1)
 	    res = -errno;
     } catch( rlog::Error &err )
@@ -670,7 +670,7 @@
 
 	rLog(Info, "removexattr %s", cyName.c_str());
 
-	res = ::removexattr( cyName.c_str(), name );
+	res = ::removexattr( cyName.c_str(), name, 0 );
 	if(res == -1)
 	    res = -errno;
     } catch( rlog::Error &err )
