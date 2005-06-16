--- c++/beeyond/BeeCertificate.h.orig	2005-06-15 20:15:38.000000000 -0700
+++ c++/beeyond/BeeCertificate.h	2005-06-15 20:15:43.000000000 -0700
@@ -137,6 +137,8 @@
 			typedef vector<Field*>::iterator fields_iterator;
 			typedef vector<Field*>::const_iterator fields_const_iterator;
 
+			BeeCertificate(InputStream& in) throw (IOException);
+
 		protected:
 			String        issuer;
 			String        subject;
@@ -150,8 +152,6 @@
 			mutable String* str;
 
 			BeeCertificate();
-			BeeCertificate(InputStream& in) throw (IOException);
-
 			bytearray* encodeTBS() const;
 
 		public:
