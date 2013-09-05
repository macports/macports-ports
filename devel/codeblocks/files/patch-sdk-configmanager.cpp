--- src/sdk/configmanager.cpp.orig
+++ src/sdk/configmanager.cpp
@@ -1442,8 +1442,10 @@ void ConfigManager::InitPaths()
 #ifdef CB_AUTOCONF
     if (plugin_path_global.IsEmpty())
     {
-        if(platform::windows || platform::macosx)
+        if(platform::windows)
             ConfigManager::plugin_path_global = data_path_global;
+        else if(platform::macosx)
+            ConfigManager::plugin_path_global = res_path + _T("/lib/codeblocks/plugins");
         else
         {
             ConfigManager::plugin_path_global = wxStandardPathsBase::Get().GetPluginsDir() + _T("/plugins");
