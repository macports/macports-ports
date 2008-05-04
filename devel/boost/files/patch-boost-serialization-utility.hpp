--- boost/serialization/utility.hpp.orig	2008-05-02 12:01:05.000000000 -0700
+++ boost/serialization/utility.hpp	2008-05-02 12:01:21.000000000 -0700
@@ -23,6 +23,7 @@
 #include <boost/type_traits/remove_const.hpp>
 #include <boost/serialization/nvp.hpp>
 #include <boost/serialization/is_bitwise_serializable.hpp>
+#include <boost/mpl/and.hpp>
 
 namespace boost { 
 namespace serialization {
