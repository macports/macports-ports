--- install.ml.bak	2006-12-06 16:22:11.000000000 -0500
+++ install.ml	2006-12-06 16:22:58.000000000 -0500
@@ -173,9 +173,6 @@
 	end;
 	if !autodoc then begin
 		run (sprintf "ocamldoc -sort -html -d %s %s" doc_dir (m_list ".mli"));
-		run ((match path_type with
-				| PathDos -> sprintf "%s odoc_style.css %s\\style.css";
-				| PathUnix -> sprintf "%s odoc_style.css %s/style.css") cp_cmd doc_dir);
 	end;
 	match install_dir with
 	  Findlib ->
@@ -194,7 +191,7 @@
 	    end;
 	    run (sprintf "%s META.txt META" cp_cmd);
 	    let files = Buffer.contents files in
-	    run (sprintf "ocamlfind install extlib %s META" files);
+	    run (sprintf "##PREFIX##/bin/ocamlfind install -destdir '##DESTDIR##' -metadir '' extlib %s META" files);
 	| Dir install_dir ->
 	    List.iter (fun m ->
 			copy (m ^ ".cmi") install_dir;
