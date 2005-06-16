--- c++/security/Security.h.orig	2005-06-15 19:39:37.000000000 -0700
+++ c++/security/Security.h	2005-06-15 19:40:14.000000000 -0700
@@ -76,7 +76,6 @@
 			typedef vector<const Provider*> provider_vector;
 			typedef provider_vector::iterator provider_vector_iterator;
 
-		private:
 			struct spi
 			{
 				Object* cspi;
@@ -89,6 +88,7 @@
 			static spi* getSpi(const String& name, const String& type) throw (NoSuchAlgorithmException);
 			static spi* getSpi(const String& algo, const String& type, const String& provider) throw (NoSuchAlgorithmException, NoSuchProviderException);
 			static spi* getSpi(const String& algo, const String& type, const Provider&) throw (NoSuchAlgorithmException);
+		private:
 			static spi* getFirstSpi(const String& type);
 
 			static const String& getKeyStoreDefault();
