--- src/discover/discover.ml.orig	2019-09-13 11:51:31.524038000 -0600
+++ src/discover/discover.ml	2019-09-13 11:55:57.423795000 -0600
@@ -37,12 +37,7 @@
 
 let search_paths =
   List.map (fun dir -> (dir ^ "/include", dir ^ "/lib")) [
-    "/usr";
-    "/usr/local";
-    "/opt";
-    "/opt/local";
-    "/sw";
-    "/mingw";
+    "@PREFIX@";
   ]
 
 let is_win = Sys.os_type = "Win32"
@@ -89,7 +84,7 @@
 let is_homebrew = ref false
 let is_macports = ref false
 let homebrew_prefix = ref "/usr/local"
-let macports_prefix = ref "/opt/local"
+let macports_prefix = ref "@PREFIX@"
 
 (* Search for a header file in standard directories. *)
 let search_header header =
@@ -252,12 +247,6 @@
 
 let () =
   Arg.parse args ignore "check for external C libraries and available features\noptions are:";
-
-  (* Test for MacOS X Homebrew. *)
-  is_homebrew :=
-    test_feature "brew"
-      (fun () ->
-         (Commands.command "brew ls --versions").Commands.stdout <> "");
 
   (* Test for MacOS X MacPorts. *)
   is_macports :=
