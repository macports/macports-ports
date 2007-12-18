--- Makefile.PL        Tue Oct 26 00:30:12 2004
+++ Makefile.PL        Tue Oct 26 00:30:13 2004
@@ -212,7 +212,7 @@
    my $self = shift ;
    return join(
       "",
-      "\npure_all :: $io_test_files\n",
+      "\n#pure_all :: $io_test_files\n",
       map(
          "\n$_ : bin/gentrevml\n$io_scheme_revmls{$_}",
        sort keys %io_scheme_revmls
