--- src/NAnt.Core/Functions/PkgConfigFunctions.cs.orig	2008-04-26 23:08:21.000000000 -0400
+++ src/NAnt.Core/Functions/PkgConfigFunctions.cs	2008-04-26 23:09:10.000000000 -0400
@@ -260,7 +260,7 @@
                 execTask.Execute();
                 ms.Position = 0;
                 StreamReader sr = new StreamReader(ms);
-                string output = sr.ReadLine();
+                string output = sr.ReadLine().Replace("\x00", "");
                 sr.Close();
                 return output;
             } catch (Exception ex) {
