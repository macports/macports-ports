--- mimms.cpp	2006-08-17 20:06:13.000000000 +0000
+++ mimms.cpp.new	2007-06-13 05:54:09.000000000 +0000
@@ -36,7 +36,7 @@
   QString url;
   Scheme  scheme;
   QString output;
-  bool    stdout;
+  bool    stdout_opt;
   bool    clobber;
   quint32 time;
   bool    verbose;
@@ -62,7 +62,7 @@
 	     "UNKNOWN"
 	     );
       qDebug("output     = '%s'", __options.output.toUtf8().data());
-      qDebug("stdout     = '%s'", __options.stdout?"true":"false");
+      qDebug("stdout     = '%s'", __options.stdout_opt?"true":"false");
       qDebug("clobber    = '%s'", __options.clobber?"true":"false");
       qDebug("time       = '%d'", __options.time);
       qDebug("verbose    = '%s'", __options.verbose?"true":"false");
@@ -87,7 +87,7 @@
     QStringList args = arguments();
     bool literal_mode = false;
 
-    __options.stdout  = false;
+    __options.stdout_opt  = false;
     __options.clobber = false;
     __options.time    = 0;
     __options.verbose = false;
@@ -160,7 +160,7 @@
 	  __options.output = args[i];
 	  if (__options.output == "-") {
 	    __options.quiet = true;
-	    __options.stdout = true;
+	    __options.stdout_opt = true;
 	  }
 	} else {
 	  qWarning("Too many arguments: '%s'", args[i].toUtf8().data());
@@ -241,7 +241,7 @@
   if (app.options().scheme == MiMMSOptions::HTTP ||
       app.options().scheme == MiMMSOptions::STDIN) {
 
-    if (!app.options().quiet && !app.options().stdout) {
+    if (!app.options().quiet && !app.options().stdout_opt) {
       out << "Searching for MMS URL...";
       out.flush();
     }
@@ -301,12 +301,12 @@
     }
   }
 
-  if (!app.options().quiet && !app.options().stdout) {
+  if (!app.options().quiet && !app.options().stdout_opt) {
     out << "\r                                                              ";
     out << "\r<" << url << ">  =>  " << "'" << file.fileName() << "'" << endl;
   }
 
-  if (!app.options().quiet && !app.options().stdout) {
+  if (!app.options().quiet && !app.options().stdout_opt) {
     out << "Connecting...";
     out.flush();
   }
@@ -389,14 +389,14 @@
 
     if (endDateTime.isValid()) {
       if (QDateTime::currentDateTime() > endDateTime) {
-	if (!app.options().quiet && !app.options().stdout) {
+	if (!app.options().quiet && !app.options().stdout_opt) {
 	  qDebug("\rRecording time limit exceeded.");
 	  break;
 	}  
       }
     }
 
-    if (!app.options().quiet && !app.options().stdout) {
+    if (!app.options().quiet && !app.options().stdout_opt) {
       off_t pos = mms ? mms_get_current_pos(mms) : mmsh_get_current_pos(mmsh);
 
       bytes_in_duration += bytes;
@@ -458,7 +458,7 @@
   file.close();
   delete buffer;
 
-  if (!app.options().quiet && !app.options().stdout) {
+  if (!app.options().quiet && !app.options().stdout_opt) {
     out << "\rStream download completed.\n";
     out.flush();
   }
