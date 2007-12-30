--- old-install.ml	2007-12-30 16:32:31.000000000 -0500
+++ install.ml	2007-12-30 16:33:29.000000000 -0500
@@ -194,7 +194,7 @@
 	    end;
 	    run (sprintf "%s META.txt META" cp_cmd);
 	    let files = Buffer.contents files in
-	    run (sprintf "ocamlfind install extlib %s META" files);
+	    run (sprintf "##PREFIX##/bin/ocamlfind install -destdir '##DESTDIR##' -metadir '' extlib %s META" files);
 	| Dir install_dir ->
 	    List.iter (fun m ->
 			copy (m ^ ".cmi") install_dir;
