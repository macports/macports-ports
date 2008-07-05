--- build_macfuse.sh
+++ build_macfuse.sh
@@ -52,11 +52,11 @@ case "$os_release" in
       exit 0
   ;;
   8*)
-      src_dir="$macfuse_dir/core/10.4/fusefs/"
+      src_dir="$macfuse_dir/macfuse-core/10.4/fusefs/"
       os_codename="Tiger"
   ;;
   9*)
-      src_dir="$macfuse_dir/core/10.5/fusefs/"
+      src_dir="$macfuse_dir/macfuse-core/10.5/fusefs/"
       os_codename="Leopard"
   ;;
   *)
