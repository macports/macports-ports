--- src/interpreter/HInteractive.hs.sav	2005-11-28 04:32:03.000000000 -0500
+++ src/interpreter/HInteractive.hs	2005-11-28 04:36:11.000000000 -0500
@@ -348,39 +348,39 @@
 help   = "hi - help command does not work in hbc < 0.9999.5"
 
 #else
-banner = "\ 
-\__   __                 __             _____________________________________\n\ 
-\||   ||  ______    ___  || _  ____     hmake interactive (hi):\n\ 
-\||___|| || || ||  ___|| ||/  ||__||      Copyright (c) May 2000\n\ 
-\||---|| || || || ||__|| ||\\_ ||__        http://www.cs.york.ac.uk/fp/hmake/\n\ 
-\||   ||                                Report bugs to: malcolm@cs.york.ac.uk\n\ 
-\||   || Version: "++hmakeVersion++"    -------------------------------------"
+banner = "\n" ++ 
+	"__   __                 __             _____________________________________\n" ++
+	"||   ||  ______    ___  || _  ____     hmake interactive (hi):\n" ++
+	"||___|| || || ||  ___|| ||/  ||__||      Copyright (c) May 2000\n" ++
+	"||---|| || || || ||__|| ||\\_ ||__        http://www.cs.york.ac.uk/fp/hmake/\n" ++
+	"||   ||                                Report bugs to: malcolm@cs.york.ac.uk\n" ++
+	"||   || Version: "++hmakeVersion++"    -------------------------------------"
 
 
-help = "\ 
-\Commands (can be abbreviated to first letter):\n\ 
-\  <expr>               evaluate expression\n\ 
-\  :type <expr>         show type of expression [nhc98 only]\n\ 
-\  :quit                quit\n\ 
-\  :Quit                quit\n\ 
-\  :load mod [mod...]   load modules (note, not filenames)\n\ 
-\  :load                clear all modules\n\ 
-\  :also mod [mod...]   load additional modules (note, not filenames)\n\ 
-\  :reload              repeat last load command\n\ 
-\  :freshen             remove, recompile, and reload all current modules\n\ 
-\  :module mod          set module scope for evaluating expressions\n\ 
-\  :edit file           edit filename\n\ 
-\  :edit                edit current module\n\ 
-\  :cd dir              change directory\n\ 
-\  :cd                  show current directory\n\ 
-\  :dir                 list current directory\n\ 
-\  :hc compiler         set Haskell compiler to use\n\ 
-\  :hc                  show current compiler and other available compilers\n\ 
-\  :set options         set hmake/compiler options\n\ 
-\  :unset options       remove hmake/compiler options\n\ 
-\  :observe name        debug function 'name' with 'Hood' [coming soon]\n\ 
-\  :trace [on|off]      switch on/off debugging with 'Hat' [nhc98 only]\n\ 
-\  :!command            shell escape\n\ 
-\  :version             show hmake version\n\ 
-\  :?                   display this list of commands"
+help = "\n" ++ 
+	"Commands (can be abbreviated to first letter):\n" ++
+	"  <expr>               evaluate expression\n" ++
+	"  :type <expr>         show type of expression [nhc98 only]\n" ++
+	"  :quit                quit\n" ++
+	"  :Quit                quit\n" ++
+	"  :load mod [mod...]   load modules (note, not filenames)\n" ++
+	"  :load                clear all modules\n" ++
+	"  :also mod [mod...]   load additional modules (note, not filenames)\n" ++
+	"  :reload              repeat last load command\n" ++
+	"  :freshen             remove, recompile, and reload all current modules\n" ++
+	"  :module mod          set module scope for evaluating expressions\n" ++
+	"  :edit file           edit filename\n" ++
+	"  :edit                edit current module\n" ++
+	"  :cd dir              change directory\n" ++
+	"  :cd                  show current directory\n" ++
+	"  :dir                 list current directory\n" ++
+	"  :hc compiler         set Haskell compiler to use\n" ++
+	"  :hc                  show current compiler and other available compilers\n" ++
+	"  :set options         set hmake/compiler options\n" ++
+	"  :unset options       remove hmake/compiler options\n" ++
+	"  :observe name        debug function 'name' with 'Hood' [coming soon]\n" ++
+	"  :trace [on|off]      switch on/off debugging with 'Hat' [nhc98 only]\n" ++
+	"  :!command            shell escape\n" ++
+	"  :version             show hmake version\n" ++
+	"  :?                   display this list of commands"
 #endif
