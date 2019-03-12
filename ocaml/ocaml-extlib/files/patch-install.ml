--- work/extlib-1.5.4/install.ml	2013-05-08 12:40:59.000000000 +0200
+++ install.ml	2013-05-25 17:50:35.000000000 +0200
@@ -210,7 +210,7 @@
 	      Buffer.add_string files ("extLib" ^ lib_ext^ " ");
 	    end;
 	    let files = Buffer.contents files in
-	    run (sprintf "ocamlfind install -patch-version %s extlib META %s" version files);
+ 	    run (sprintf "##PREFIX##/bin/ocamlfind install -destdir '##DESTDIR##' -metadir '' -patch-version %s extlib META %s" version files);
 	| Dir install_dir ->
 	    List.iter (fun m ->
 			copy (m ^ ".cmi") install_dir;
