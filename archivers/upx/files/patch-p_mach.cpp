--- src/p_mach.cpp	Sun Sep 27 20:08:49 2009 +0200
+++ src/p_mach.cpp	Thu Oct 08 12:53:02 2009 -0700
@@ -1170,6 +1170,7 @@
 
         ph.u_file_size = fat_head.arch[j].size;
         fi->set_extent(fat_head.arch[j].offset, fat_head.arch[j].size);
+        fi->seek(0, SEEK_SET);
         switch (fat_head.arch[j].cputype) {
         case PackMachFat::CPU_TYPE_I386: {
             typedef N_Mach::Mach_header<MachClass_LE32::MachITypes> Mach_header;
@@ -1237,6 +1238,7 @@
 
         ph.u_file_size = fat_head.arch[j].size;
         fi->set_extent(fat_head.arch[j].offset, fat_head.arch[j].size);
+        fi->seek(0, SEEK_SET);
         switch (fat_head.arch[j].cputype) {
         case PackMachFat::CPU_TYPE_I386: {
             N_Mach::Mach_header<MachClass_LE32::MachITypes> hdr;
@@ -1294,6 +1296,7 @@
     }
     for (unsigned j=0; j < fat_head.fat.nfat_arch; ++j) {
         fi->set_extent(fat_head.arch[j].offset, fat_head.arch[j].size);
+        fi->seek(0, SEEK_SET);
         switch (arch[j].cputype) {
         default: return false;
         case PackMachFat::CPU_TYPE_I386: {
@@ -1335,6 +1338,7 @@
     }
     for (unsigned j=0; j < fat_head.fat.nfat_arch; ++j) {
         fi->set_extent(fat_head.arch[j].offset, fat_head.arch[j].size);
+        fi->seek(0, SEEK_SET);
         switch (arch[j].cputype) {
         default: return false;
         case PackMachFat::CPU_TYPE_I386: {
