--- git-instaweb.sh.orig	2007-11-02 12:50:47.000000000 -0700
+++ git-instaweb.sh	2007-11-02 13:03:42.000000000 -0700
@@ -206,10 +206,14 @@ EOF
 }
 
 script='
-s#^\(my\|our\) $projectroot =.*#\1 $projectroot = "'`dirname $fqgitdir`'";#
-s#\(my\|our\) $gitbin =.*#\1 $gitbin = "'$GIT_EXEC_PATH'";#
-s#\(my\|our\) $projects_list =.*#\1 $projects_list = $projectroot;#
-s#\(my\|our\) $git_temp =.*#\1 $git_temp = "'$fqgitdir/gitweb/tmp'";#'
++s#^my $projectroot =.*#my $projectroot = "'`dirname $fqgitdir`'";#
++s#^our $projectroot =.*#our $projectroot = "'`dirname $fqgitdir`'";#
++s#my $gitbin =.*#my $gitbin = "'$GIT_EXEC_PATH'";#
++s#our $gitbin =.*#our $gitbin = "'$GIT_EXEC_PATH'";#
++s#my $projects_list =.*#my $projects_list = $projectroot;#
++s#our $projects_list =.*#our $projects_list = $projectroot;#
++s#my $git_temp =.*#my $git_temp = "'$fqgitdir/gitweb/tmp'";#
++s#our $git_temp =.*#our $git_temp = "'$fqgitdir/gitweb/tmp'";#'
 
 gitweb_cgi () {
 	cat > "$1.tmp" <<\EOFGITWEB
