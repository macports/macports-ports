--- auto_map.h	2004/06/17 20:59:44	1.8
+++ auto_map.h	2008/03/03 06:41:59	1.9
@@ -23,10 +23,10 @@
 #include <assert.h>
 #include <map>
 
-template <class K, class T, template <class BK, class BT> class Base>
-class auto_map_base : public Base<K, restricted_ptr<T> > {
+template <class K, class T,  class Base>
+class auto_map_base : public Base {
 	protected:
-		typedef Base<K, restricted_ptr<T> > super;
+		typedef Base super;
 	public:
 		typedef typename super::iterator iterator;
 
@@ -55,9 +55,9 @@
 
 
 template <class K, class T>
-class auto_map : public auto_map_base<K, T, std::map> {
+class auto_map : public auto_map_base<K, T, std::map<K, restricted_ptr<T> > > {
 	public:
-		typedef typename auto_map_base<K, T, std::map>::super super;
+		typedef typename auto_map_base<K, T, std::map<K, restricted_ptr<T> > >::super super;
 		typedef typename super::iterator iterator;
 		typedef typename super::value_type value_type;
 		/*super::value_type value_type(const K &k, T*p) {
@@ -74,9 +74,9 @@
 };
 
 template <class K, class T>
-class auto_multimap : public auto_map_base<K, T, std::multimap> {
+class auto_multimap : public auto_map_base<K, T, std::multimap<K, restricted_ptr<T> > > {
 	public:
-		typedef typename auto_map_base<K, T, std::multimap>::super super;
+		typedef typename auto_map_base<K, T, std::multimap<K, restricted_ptr<T> > >::super super;
 		typedef typename super::iterator iterator;
 		typedef typename super::value_type value_type;
 		iterator insert_value(const K &k, T* p) { //we can't really use the normal insert funcs, but we don't want to just name it insert since it would be easy to confuse with all the normal map insert funcs
