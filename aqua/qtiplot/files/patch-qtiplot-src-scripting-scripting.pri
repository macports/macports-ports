This fixes an issue with SIP >= 4.9
It's already fixed upstream in versions > 0.9.7.10
--- qtiplot/src/scripting/scripting.pri.orig	2009-11-03 22:25:47.000000000 +0100
+++ qtiplot/src/scripting/scripting.pri	2009-11-03 22:27:16.000000000 +0100
@@ -80,7 +80,6 @@
              $${SIP_DIR}/sipqtiPythonScript.cpp\
              $${SIP_DIR}/sipqtiPythonScripting.cpp\
              $${SIP_DIR}/sipqtiFolder.cpp\
-             $${SIP_DIR}/sipqtiQList.cpp\
              $${SIP_DIR}/sipqtiFit.cpp \
              $${SIP_DIR}/sipqtiExponentialFit.cpp \
              $${SIP_DIR}/sipqtiTwoExpFit.cpp \
@@ -105,4 +104,14 @@
 			 $${SIP_DIR}/sipqtiCorrelation.cpp \
 			 $${SIP_DIR}/sipqtiConvolution.cpp \
 			 $${SIP_DIR}/sipqtiDeconvolution.cpp \
+
+exists(../../$${SIP_DIR}/sipqtiQList.cpp) {
+  # SIP < 4.9
+  SOURCES += $${SIP_DIR}/sipqtiQList.cpp
+} else {
+  SOURCES += \
+       $${SIP_DIR}/sipqtiQList0101Folder.cpp\
+       $${SIP_DIR}/sipqtiQList0101Graph.cpp\
+       $${SIP_DIR}/sipqtiQList0101MdiSubWindow.cpp\
+}
 }
