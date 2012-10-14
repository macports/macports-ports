--- src/systemclock.cpp.orig	2012-10-13 23:07:50.000000000 -0400
+++ src/systemclock.cpp	2012-10-13 23:07:56.000000000 -0400
@@ -67,7 +67,7 @@
 template<typename Key, typename Value>
 void MinHeap<Key, Value>::Insert(Key k, Value v)
 {
-	resize(this->size()+1);
+	this->resize(this->size()+1);
 	for(unsigned i = this->size();;) {
 		unsigned parent = i/2;
 		if(parent == 0 || (*this)[parent-1].first < k) {
