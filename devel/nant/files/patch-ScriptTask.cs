--- src/NAnt.DotNet/Tasks/ScriptTask.cs.orig	2008-04-26 23:06:17.000000000 -0400
+++ src/NAnt.DotNet/Tasks/ScriptTask.cs	2008-04-26 23:07:28.000000000 -0400
@@ -516,7 +516,7 @@
         #region Private Static Methods
 
         private static CodeDomProvider CreateCodeDomProvider(string typeName, string assemblyName) {
-            Assembly providerAssembly = Assembly.LoadWithPartialName(assemblyName);
+            Assembly providerAssembly = Assembly.Load(assemblyName);
             if (providerAssembly == null) {
                 throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                     ResourceUtils.GetString("NA2037"), assemblyName));
