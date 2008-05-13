# Fedora: yum-2.9-api.patch
--- repoview.py.orig	2006-07-04 20:53:55.000000000 -0400
+++ repoview.py	2006-07-04 21:21:56.000000000 -0400
@@ -42,7 +42,7 @@
 try:
     from yum.comps import Comps, CompsException
     from yum.mdparser import MDParser
-    from repomd.repoMDObject import RepoMD
+    from yum.repoMDObject import RepoMD
 except ImportError:
     try:
         from noyum.comps import Comps, CompsException
@@ -364,7 +364,7 @@
         except IOError: 
             return 1
         checksum = checksum.strip()
-        if checksum != self.repodata['primary']['checksum'][1]: 
+        if checksum != self.repodata['primary'].checksum[1]: 
             return 1
         _say("RepoView: Repository has not changed. Force the run with -f.\n")
         sys.exit(0)
@@ -374,7 +374,7 @@
         Utility method for parsing comps.xml.
         """
         _say('parsing comps...', 1)
-        loc = self.repodata['group']['relativepath']
+        loc = self.repodata['group'].location[1]
         comps = Comps()
         try:
             comps.add(os.path.join(self.repodir, loc))
@@ -436,7 +436,7 @@
         Utility method for processing primary.xml.
         """
         _say('parsing primary...', 1)
-        loc = self.repodata['primary']['relativepath']
+        loc = self.repodata['primary'].location[1]
         mdp = MDParser(os.path.join(self.repodir, loc))
         ignored = 0
         for package in mdp:
@@ -507,7 +507,7 @@
         Utility method to get data from other.xml.
         """
         _say('parsing other...', 1)
-        loc = self.repodata['other']['relativepath']
+        loc = self.repodata['other'].location[1]
         otherxml = os.path.join(self.repodir, loc)
         ignored = 0
         mdp = MDParser(otherxml)
@@ -789,7 +789,7 @@
         _say('writing checksum...', 1)
         chkfile = os.path.join(self.outdir, 'checksum')
         fh = open(chkfile, 'w')
-        fh.write(self.repodata['primary']['checksum'][1])
+        fh.write(self.repodata['primary'].checksum[1])
         fh.close()
         _say('done\n')
         _say('Moving new repoview dir in place...', 1)
