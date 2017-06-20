--- lib/Biber/Constants.pm	2017-06-20 17:58:59.000000000 +0200
+++ lib/Biber/Constants.pm	2017-06-20 17:59:06.000000000 +0200
@@ -3,6 +3,7 @@
 use strict;
 use warnings;
 
+use Encode;
 use Encode::Alias;
 
 use parent qw(Exporter);
