--- src/alias_manager.pl  Tue Aug  9 09:02:35 2005
+++ src/alias_manager.pl Sat Feb 18 01:51:52 2006
@@ -43,7 +43,7 @@
 my $tmp_alias_file = $Conf{'tmpdir'}.'/sympa_aliases.'.time;


-my $alias_wrapper = '--MAILERPROGDIR--/aliaswrapper';
+my $alias_wrapper = '--LIBEXECDIR--/aliaswrapper';
 my $lock_file = '--EXPL_DIR--/alias_manager.lock';
 my $default_domain;
 my $path_to_queue = '--MAILERPROGDIR--/queue';
