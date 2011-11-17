--- src/NAnt.DotNet/Tasks/ScriptTask.cs.orig	2011-09-17 15:08:23.000000000 -0500
+++ src/NAnt.DotNet/Tasks/ScriptTask.cs	2011-11-17 15:19:28.000000000 -0600
@@ -517,7 +517,7 @@
         #region Private Static Methods
 
         private static CodeDomProvider CreateCodeDomProvider(string typeName, string assemblyName) {
-            Assembly providerAssembly = Assembly.LoadWithPartialName(assemblyName);
+            Assembly providerAssembly = Assembly.Load(assemblyName);
             if (providerAssembly == null) {
                 throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                     ResourceUtils.GetString("NA2037"), assemblyName));
