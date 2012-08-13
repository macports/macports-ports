--- install.ml	2011-08-06 15:01:32.000000000 +0200
+++ install.ml	2012-08-13 22:26:14.000000000 +0200
@@ -174,8 +174,8 @@
 	if !autodoc then begin
 		run (sprintf "ocamldoc -sort -html -d %s %s" doc_dir (m_list ".mli"));
 		run ((match path_type with
-				| PathDos -> sprintf "%s odoc_style.css %s\\style.css";
-				| PathUnix -> sprintf "%s odoc_style.css %s/style.css") cp_cmd doc_dir);
+				| PathDos -> sprintf "%s doc/style.css %s\\style.css";
+				| PathUnix -> sprintf "%s doc/style.css %s/style.css") cp_cmd doc_dir);
 	end;
 	match install_dir with
 	  Findlib ->
@@ -193,7 +193,7 @@
 	      Buffer.add_string files ("extLib" ^ lib_ext^ " ");
 	    end;
 	    let files = Buffer.contents files in
-	    run (sprintf "ocamlfind install extlib %s META" files);
+	    run (sprintf "##PREFIX##/bin/ocamlfind install -destdir '##DESTDIR##' -metadir '' extlib %s META" files);
 	| Dir install_dir ->
 	    List.iter (fun m ->
 			copy (m ^ ".cmi") install_dir;
