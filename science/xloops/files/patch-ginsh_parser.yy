--- ginsh/ginac/ginsh_parser.yy.sav	Sat Oct  9 14:01:44 2004
+++ ginsh/ginac/ginsh_parser.yy	Sat Oct  9 14:02:35 2004
@@ -29,13 +29,14 @@
 %{
 #include "config.h"
 
-#include <sys/resource.h>
-
 #if HAVE_UNISTD_H
 #include <sys/types.h>
 #include <unistd.h>
 #endif
 
+#include <sys/time.h>
+#include <sys/resource.h>
+
 #include <stdexcept>
 
 #include "ginsh.h"
@@ -803,7 +804,7 @@
 		// For shell commands, revert back to filename completion
 		rl_completion_append_character = orig_completion_append_character;
 		rl_basic_word_break_characters = orig_basic_word_break_characters;
-		rl_completer_word_break_characters = rl_basic_word_break_characters;
+		rl_completer_word_break_characters = (char *)rl_basic_word_break_characters;
 #if (GINAC_RL_VERSION_MAJOR < 4) || (GINAC_RL_VERSION_MAJOR == 4 && GINAC_RL_VERSION_MINOR < 2)
 		return completion_matches(const_cast<char *>(text), (CPFunction *)filename_completion_function);
 #else
@@ -813,7 +814,7 @@
 		// Otherwise, complete function names
 		rl_completion_append_character = '(';
 		rl_basic_word_break_characters = " \t\n\"#$%&'()*+,-./:;<=>?@[\\]^`{|}~";
-		rl_completer_word_break_characters = rl_basic_word_break_characters;
+		rl_completer_word_break_characters = (char *)rl_basic_word_break_characters;
 #if (GINAC_RL_VERSION_MAJOR < 4) || (GINAC_RL_VERSION_MAJOR == 4 && GINAC_RL_VERSION_MINOR < 2)
 		return completion_matches(const_cast<char *>(text), (CPFunction *)fcn_generator);
 #else
