--- configure.py.orig	2012-12-08 05:05:54.000000000 -0500
+++ configure.py	2012-12-10 10:11:01.000000000 -0500
@@ -44,6 +44,7 @@
 qt_dir = None
 qt_incdir = None
 qt_libdir = None
+qt_frameworkdir = None
 qt_bindir = None
 qt_datadir = None
 qt_pluginsdir = None
@@ -1004,16 +1005,9 @@
                     dynamic_pylib = "--enable-shared" in config_args
 
                 if dynamic_pylib:
-                    if glob.glob("%s/lib/libpython%d.%d*" % (ducfg["exec_prefix"], py_major, py_minor)):
-                        lib_dir_flag = quote("-L%s/lib" % ducfg["exec_prefix"])
-                    elif glob.glob("%s/libpython%d.%d*" % (ducfg["LIBDIR"], py_major, py_minor)):
-                        lib_dir_flag = quote("-L%s" % ducfg["LIBDIR"])
-                    else:
-                        sipconfig.inform("Qt Designer plugin disabled because Python library couldn't be found")
-                        lib_dir_flag = ''
-                        opts.designer_plugin = False
 
-                    link = "%s -lpython%d.%d%s" % (lib_dir_flag, py_major, py_minor, abi)
+                    link = "%s @@MACPORTS_PYTHON_FRAMEWORK@@" % sipcfg.build_macros().get('LFLAGS', '')
+
                 else:
                     sipconfig.inform("Qt Designer plugin disabled because Python library is static")
                     opts.designer_plugin = False
@@ -1112,7 +1106,10 @@
 
     sipconfig.inform("SIP %s is being used." % sipcfg.sip_version_str)
     sipconfig.inform("The Qt header files are in %s." % qt_incdir)
-    sipconfig.inform("The %s Qt libraries are in %s." % (lib_type, qt_libdir))
+    if sys.platform == "darwin" and qt_framework:
+        sipconfig.inform("The %s Qt frameworks are in %s." % (lib_type, qt_frameworkdir))
+    else:
+        sipconfig.inform("The %s Qt libraries are in %s." % (lib_type, qt_libdir))
     sipconfig.inform("The Qt binaries are in %s." % qt_bindir)
     sipconfig.inform("The Qt mkspecs directory is in %s." % qt_datadir)
     sipconfig.inform("These PyQt modules will be built: %s." % ", ".join(pyqt_modules))
@@ -1175,7 +1172,8 @@
         "qt_dir":             qt_dir,
         "qt_data_dir":        qt_datadir,
         "qt_inc_dir":         qt_incdir,
-        "qt_lib_dir":         qt_libdir
+        "qt_lib_dir":         qt_libdir,
+        "qt_framework_dir":   qt_frameworkdir
     }
 
     sipconfig.create_config_module(module, template, content, macros)
@@ -1824,7 +1822,7 @@
             lfile = license.LicenseFile
         except AttributeError:
             lfile = None
-    except ImportError:
+    except:
         ltype = None
 
     if ltype is None:
@@ -1931,12 +1929,14 @@
     names = list(sipcfg.build_macros().keys())
     names.append("INCDIR_QT")
     names.append("LIBDIR_QT")
+    names.append("FRAMEWORKDIR_QT")
     names.append("MOC")
 
     properties = {
         "QT_INSTALL_BINS":      qt_bindir,
         "QT_INSTALL_HEADERS":   qt_incdir,
-        "QT_INSTALL_LIBS":      qt_libdir
+        "QT_INSTALL_LIBS":      qt_libdir,
+        "QT_INSTALL_FRAMEWORKS": qt_frameworkdir
     }
 
     macros = sipconfig.parse_build_macros(fname, names, overrides, properties)
@@ -1982,7 +1982,7 @@
 
     # Work out how Qt was built on MacOS.
     if sys.platform == "darwin":
-        if os.access(os.path.join(qt_libdir, "QtCore.framework"), os.F_OK):
+        if os.access(os.path.join(qt_frameworkdir, "QtCore.framework"), os.F_OK):
             global qt_framework
             qt_framework = 1
 
@@ -1999,6 +1999,7 @@
     sipcfg.qt_threaded = 1
     sipcfg.qt_dir = qt_dir
     sipcfg.qt_lib_dir = qt_libdir
+    sipcfg.qt_framework_dir = qt_frameworkdir
 
     return ConfigurePyQt4(generator)
 
@@ -2014,7 +2015,7 @@
 
 
 def get_qt_configuration():
-    """Set the qt_dir, qt_incdir, qt_libdir, qt_bindir, qt_datadir,
+    """Set the qt_dir, qt_incdir, qt_libdir, qt_frameworkdir, qt_bindir, qt_datadir,
     qt_pluginsdir and qt_xfeatures globals for the Qt installation.
     """
     sipconfig.inform("Determining the layout of your Qt installation...")
@@ -2087,6 +2088,7 @@
     out << QLibraryInfo::location(QLibraryInfo::PrefixPath) << '\\n';
     out << QLibraryInfo::location(QLibraryInfo::HeadersPath) << '\\n';
     out << QLibraryInfo::location(QLibraryInfo::LibrariesPath) << '\\n';
+    out << QLibraryInfo::location(QLibraryInfo::FrameworksPath) << '\\n';
     out << QLibraryInfo::location(QLibraryInfo::BinariesPath) << '\\n';
     out << QLibraryInfo::location(QLibraryInfo::DataPath) << '\\n';
     out << QLibraryInfo::location(QLibraryInfo::PluginsPath) << '\\n';
@@ -2209,20 +2211,21 @@
     lines = f.read().strip().split("\n")
     f.close()
 
-    global qt_dir, qt_incdir, qt_libdir, qt_bindir, qt_datadir, qt_pluginsdir
+    global qt_dir, qt_incdir, qt_libdir, qt_frameworkdir, qt_bindir, qt_datadir, qt_pluginsdir
     global qt_version, qt_edition, qt_licensee, qt_shared, qt_xfeatures
 
     qt_dir = lines[0]
     qt_incdir = lines[1]
     qt_libdir = lines[2]
-    qt_bindir = lines[3]
-    qt_datadir = lines[4]
-    qt_pluginsdir = lines[5]
-    qt_version = lines[6]
-    qt_edition = lines[7]
-    qt_licensee = lines[8]
-    qt_shared = lines[9]
-    qt_xfeatures = lines[10:]
+    qt_frameworkdir = lines[3]
+    qt_bindir = lines[4]
+    qt_datadir = lines[5]
+    qt_pluginsdir = lines[6]
+    qt_version = lines[7]
+    qt_edition = lines[8]
+    qt_licensee = lines[9]
+    qt_shared = lines[10]
+    qt_xfeatures = lines[11:]
 
     if opts.assume_shared:
         qt_shared = "shared"
