--- setup.py	Fri Sep  3 03:26:40 2004
+++ ../setup.py	Thu Sep 16 18:18:38 2004
@@ -29,11 +29,5 @@
        license = "GNU Public License",
        ext_modules = [ Extension( "pytiff",
                                   sources = ["pytiff.c"],
-                                  libraries = ["tiff"]) ],
-       data_files = [ ("local/share/doc/pytiff/testimages", ["testimages/cramps.tif",
-                                                       "testimages/fax2d.tif",
-                                                       "testimages/g3test.tif",
-                                                       "testimages/horse.tif"] ),
-                      ("local/share/doc/pytiff", ["test_pytiff.py", "pytiff.html", "README", "CHANGES"] )
-                      ]
+                                  libraries = ["tiff"]) ]
        )
