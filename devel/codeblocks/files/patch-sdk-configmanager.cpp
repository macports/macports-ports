written by afb

properly sets the directory where CB looks for plugins

--- src/sdk/configmanager.cpp.orig
+++ src/sdk/configmanager.cpp
@@ -1504,8 +1504,10 @@ void ConfigManager::InitPaths()
 #ifdef CB_AUTOCONF
     if (plugin_path_global.IsEmpty())
     {
-        if (platform::windows || platform::macosx)
+        if (platform::windows)
             ConfigManager::plugin_path_global = data_path_global;
+        else if (platform::macosx)
+            ConfigManager::plugin_path_global = res_path + _T("/lib/codeblocks/plugins");
         else
         {
             // It seems we can not longer rely on wxStandardPathsBase::Get().GetPluginsDir(),
