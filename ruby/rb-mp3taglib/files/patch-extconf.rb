--- extconf.rb	Wed Aug 27 07:02:53 2003
+++ ../mp3taglib-0.6-patched/extconf.rb	Sat Dec 18 01:19:07 2004
@@ -3,15 +3,16 @@
 require 'mkmf'
 create_makefile("c_mp3tag")
 
+=begin
 arr=Array::new
 File::open("Makefile","r"){|f|
   arr=f.readlines
     arr.map!{|l|
     if l=~/^LDSHARED/
-      "LDSHARED = g++ -shared"
+      "LDSHARED = g++ "
     else
       if l=~/^LIBS/
-	"LIBS = $(LIBRUBY_A) -lc -ldl -lcrypt -lm -lid3 -lz "
+	"LIBS = $(LIBRUBY) -lc -ldl -lm -lid3 -lz "
       else
 	l
       end
@@ -24,4 +25,4 @@
     f.puts(l)
   }
 }
-
+=end
