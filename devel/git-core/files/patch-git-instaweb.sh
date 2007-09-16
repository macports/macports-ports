diff --git git-instaweb.sh.orig git-instaweb.sh
index b79c6b6..9e9253a 100755
--- git-instaweb.sh.orig
+++ git-instaweb.sh
@@ -30,8 +30,7 @@ test -z "$port" && port=1234
 
 start_httpd () {
 	httpd_only="`echo $httpd | cut -f1 -d' '`"
-	if test "`expr index $httpd_only /`" -eq '1' || \
-				which $httpd_only >/dev/null
+	if test echo $http_only | grep ^/ || which $httpd_only >/dev/null
 	then
 		$httpd $fqgitdir/gitweb/httpd.conf
 	else
@@ -207,10 +206,14 @@ EOF
 }
 
 script='
-s#^\(my\|our\) $projectroot =.*#\1 $projectroot = "'`dirname $fqgitdir`'";#
-s#\(my\|our\) $gitbin =.*#\1 $gitbin = "'$GIT_EXEC_PATH'";#
-s#\(my\|our\) $projects_list =.*#\1 $projects_list = $projectroot;#
-s#\(my\|our\) $git_temp =.*#\1 $git_temp = "'$fqgitdir/gitweb/tmp'";#'
+s#^my $projectroot =.*#my $projectroot = "'`dirname $fqgitdir`'";#
+s#^our $projectroot =.*#our $projectroot = "'`dirname $fqgitdir`'";#
+s#my $gitbin =.*#my $gitbin = "'$GIT_EXEC_PATH'";#
+s#our $gitbin =.*#our $gitbin = "'$GIT_EXEC_PATH'";#
+s#my $projects_list =.*#my $projects_list = $projectroot;#
+s#our $projects_list =.*#our $projects_list = $projectroot;#
+s#my $git_temp =.*#my $git_temp = "'$fqgitdir/gitweb/tmp'";#
+s#our $git_temp =.*#our $git_temp = "'$fqgitdir/gitweb/tmp'";#'
 
 gitweb_cgi () {
 	cat > "$1.tmp" <<\EOFGITWEB
