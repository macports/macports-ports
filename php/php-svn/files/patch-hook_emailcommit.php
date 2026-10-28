--- examples/hook_emailcommit.php.orig	2009-09-23 22:08:17.000000000 -0500
+++ examples/hook_emailcommit.php	2009-11-28 03:27:18.000000000 -0600
@@ -36,8 +36,7 @@
         $this->rev  = (int) $this->rev;
         $last = $this->rev -1 ;
         // techncially where the diff is!?
-        require_once 'System.php';
-        $svn = System::which('svn','/usr/bin/svn');
+        $svn = '@PREFIX@/bin/svn';
         
         $cmd = "$svn diff -r{$last}:{$this->rev} $this->repos";
         $this->log = svn_log($this->repos, $this->rev,  $this->rev-1, 0, SVN_DISCOVER_CHANGED_PATHS);
@@ -124,7 +123,7 @@
             $this->writeFile($tmp , 
                     svn_cat($this->repos . $action['path'],$this->rev));
             
-            $data = $data = `/usr/bin/php -l $tmp`;
+            $data = $data = `@PREFIX@/bin/php -l $tmp`;
             unlink($tmp);
             if (preg_match('/^No syntax errors/',$data)) {
                 continue;
