Index: zeroinstall/injector/distro.py
===================================================================
--- zeroinstall/injector/distro.py	(revision 2053)
+++ zeroinstall/injector/distro.py	(arbetskopia)
@@ -228,12 +228,112 @@
 		impl = factory('package:rpm:%s:%s' % (package, version)) 
 		impl.version = model.parse_version(version)
 
+class MacPortsDistribution(Distribution):
+	cache_leaf = 'mp-status.cache'
+	
+	def __init__(self, db_dir):
+		self.db_dir = db_dir
+		rcpt_status = os.path.join(db_dir, 'receipts')
+		self.status_details = os.stat(rcpt_status)
+
+		self.versions = {}
+		self.cache_dir=basedir.save_cache_path(namespaces.config_site,
+						       namespaces.config_prog)
+
+		try:
+			self.load_cache()
+		except Exception, ex:
+			info("Failed to load cache (%s). Regenerating...",
+			     ex)
+			try:
+				self.generate_cache()
+				self.load_cache()
+			except Exception, ex:
+				warn("Failed to regenerate cache: %s", ex)
+
+	def load_cache(self):
+		stream = file(os.path.join(self.cache_dir, self.cache_leaf))
+
+		for line in stream:
+			if line == '\n':
+				break
+			name, value = line.split(': ')
+			if name == 'mtime' and (int(value) !=
+					    int(self.status_details.st_mtime)):
+				raise Exception("Modification time of mp status file has changed")
+			if name == 'size' and (int(value) !=
+					       self.status_details.st_size):
+				raise Exception("Size of mp status file has changed")
+		else:
+			raise Exception('Invalid cache format (bad header)')
+			
+		versions = self.versions
+		for line in stream:
+			package, version = line[:-1].split('\t')
+			versions[package] = version
+
+	def __parse_port_line(self, line):
+
+		package, version, category = line.strip().split()
+		if version.startswith('@'):
+			version = version.lstrip('@')
+		if '_' in version:
+			# MacPorts's 'revision' system
+			version = version.split('_', 1)[0]
+		clean_version = try_cleanup_distro_version(version)
+		if clean_version:
+			return package, clean_version
+		else:
+			return None, None
+		
+	def generate_cache(self):
+		cache = []
+
+		for line in os.popen("port list installed"):
+			package, version = self.__parse_port_line(line)
+			if package and version:
+				cache.append('%s\t%s' % (package, version))
+
+		cache = list(set(cache))    # Remove duplicates (from images)
+		cache.sort()   # Might be useful later; currently we don't care
+		
+		import tempfile
+		fd, tmpname = tempfile.mkstemp(prefix = 'mp-cache-tmp',
+					       dir = self.cache_dir)
+		try:
+			stream = os.fdopen(fd, 'wb')
+			stream.write('mtime: %d\n' % int(self.status_details.st_mtime))
+			stream.write('size: %d\n' % self.status_details.st_size)
+			stream.write('\n')
+			for line in cache:
+				stream.write(line + '\n')
+			stream.close()
+
+			os.rename(tmpname,
+				  os.path.join(self.cache_dir,
+					       self.cache_leaf))
+		except:
+			os.unlink(tmpname)
+			raise
+
+	def get_package_info(self, package, factory):
+		try:
+			version = self.versions[package]
+		except KeyError:
+			return
+
+		impl = factory('package:mp:%s:%s' % (package, version)) 
+		impl.version = model.parse_version(version)
+
 _dpkg_db_dir = '/var/lib/dpkg'
 _rpm_db_dir = '/var/lib/rpm'
+_mp_db_dir = '/opt/local/var/macports'
 
 if os.path.isdir(_dpkg_db_dir):
 	host_distribution = DebianDistribution(_dpkg_db_dir)
 elif os.path.isdir(_rpm_db_dir):
 	host_distribution = RPMDistribution(_rpm_db_dir)
+elif os.path.isdir(_mp_db_dir):
+	host_distribution = MacPortsDistribution(_mp_db_dir)
 else:
 	host_distribution = Distribution()
