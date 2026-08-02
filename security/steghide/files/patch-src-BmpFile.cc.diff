--- src/BmpFile.cc.orig	2011-06-21 15:28:36.000000000 +0200
+++ src/BmpFile.cc	2011-06-21 15:28:40.000000000 +0200
@@ -214,10 +214,10 @@
 		// create reservoir - for every i reservoir[i] contains the sample values that are neighbourss of
 		// the sample value with label i and have a lower label (and have already been found)
 		// This is necessary to use collapsing trees together with bucket sort (without huge increase in memory usage)
-		std::vector<BmpRGBSampleValue*> reservoir[svs.size()] ;
+		std::vector<std::vector<BmpRGBSampleValue*> > reservoir(svs.size()) ;
 
 		// neighbours sorted by distance (for the current source sample value)
-		std::vector<BmpRGBSampleValue*> neighbours_byd[r + 1] ;
+		std::vector<std::vector<BmpRGBSampleValue*> > neighbours_byd(r + 1) ;
 
 		for (std::vector<SampleValue*>::const_iterator srcsvit = svs.begin() ; srcsvit != svs.end() ; srcsvit++) {
 			BmpRGBSampleValue* srcsv = (BmpRGBSampleValue*) (*srcsvit) ;
