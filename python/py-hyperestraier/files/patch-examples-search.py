--- examples/search.py.orig	2005-08-15 02:56:31.000000000 +0900
+++ examples/search.py	2006-03-24 00:38:48.000000000 +0900
@@ -20,17 +20,12 @@
 result = db.search(cond, 0)
 
 # for each document in result
-<<<<<<< search.py
-doc = result.next()
-while doc:
-	print doc.get_id()
-=======
+
 for i in result:
 	print "id = ", i
 	# get the document
 	doc = db.get_doc(i, 0)
-
->>>>>>> 1.10
+	
 	# display attributes
 	for attr_name in doc.attr_names():
 		print "%s	: %s" % (attr_name, doc.attr(attr_name))
