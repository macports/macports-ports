--- cryptopp/cryptlib.h.orig	2005-04-06 21:25:27.000000000 -0700
+++ cryptopp/cryptlib.h	2005-04-06 21:25:57.000000000 -0700
@@ -300,7 +300,7 @@
 	}
 
 	//! to be implemented by derived classes, users should use one of the above functions instead
-	CRYPTOPP_DLL virtual bool GetVoidValue(const char *name, const std::type_info &valueType, void *pValue) const =0;
+	CRYPTOPP_DLL bool GetVoidValue(const char *name, const std::type_info &valueType, void *pValue) const;
 };
 
 //! namespace containing value name definitions
