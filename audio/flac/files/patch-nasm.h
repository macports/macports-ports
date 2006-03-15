--- src/libFLAC/ia32/nasm.h~	2005-01-25 13:14:22.000000000 +0900
+++ src/libFLAC/ia32/nasm.h	2006-03-15 18:07:23.000000000 +0900
@@ -49,6 +49,11 @@
 	%idefine code_section section .text align=16
 	%idefine data_section section .data align=32
 	%idefine bss_section  section .bss  align=32
+%elifdef OBJ_FORMAT_macho
+	%define FLAC__PUBLIC_NEEDS_UNDERSCORE
+	%idefine code_section section .text
+	%idefine data_section section .data
+	%idefine bss_section  section .bss
 %else
 	%error unsupported object format!
 %endif
