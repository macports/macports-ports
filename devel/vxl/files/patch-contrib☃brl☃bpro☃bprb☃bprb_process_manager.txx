--- contrib/brl/bpro/bprb/bprb_process_manager.txx.orig	2008-12-02 23:11:38.000000000 -0800
+++ contrib/brl/bpro/bprb/bprb_process_manager.txx	2008-12-02 23:13:00.000000000 -0800
@@ -107,8 +107,8 @@
 
 #undef BPRB_PROCESS_MANAGER_INSTANTIATE
 #define BPRB_PROCESS_MANAGER_INSTANTIATE(T) \
-template class bprb_process_manager<T >; \
 template <class T > T* bprb_process_manager<T >::instance_ = 0; \
-template <class T > vcl_map< vcl_string , bprb_process_sptr > bprb_process_manager<T >::process_map
+template <class T > vcl_map< vcl_string , bprb_process_sptr > bprb_process_manager<T >::process_map; \
+template class bprb_process_manager<T >
 
 #endif // bprb_process_manager_txx_
