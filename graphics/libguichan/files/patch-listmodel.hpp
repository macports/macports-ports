--- include/guichan/listmodel.hpp	2005-05-17 22:23:06.000000000 +0300
+++ include/guichan/listmodel.hpp	2006-06-30 10:56:11.000000000 +0300
@@ -85,6 +85,8 @@
          * @return an element as a string.
          */
         virtual std::string getElementAt(int i) = 0;
+
+	virtual ~ListModel() {};
     };
 }
 
