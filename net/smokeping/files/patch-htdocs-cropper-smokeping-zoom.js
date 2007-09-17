--- htdocs/cropper/smokeping-zoom.js.orig   (revision 834)
+++ htdocs/cropper/smokeping-zoom.js   (revision 837)
@@ -55,11 +55,20 @@
     var myURL = myURLObj.getUrlBase();

     // Generate Selected Range in Unix Timestamps
+    var LeftFactor = 1;
+    var RightFactor = 1;

-    var NewStartEpoch = Math.floor(StartEpoch + (SelectLeft  - RRDLeft) * DivEpoch / RRDImgUsable );
-    EndEpoch  =  Math.ceil(StartEpoch + (SelectRight - RRDLeft) * DivEpoch / RRDImgUsable );
-    StartEpoch = NewStartEpoch;
+    if (SelectLeft < RRDLeft)
+        LeftFactor = 10;

+    StartEpoch = Math.floor(StartEpoch + (SelectLeft  - RRDLeft) * DivEpoch / RRDImgUsable * LeftFactor );
+
+    if (SelectRight > RRDImgWidth - RRDRight)
+        RightFactor = 10;
+
+    EndEpoch  =  Math.ceil(EndEpoch + (SelectRight - (RRDImgWidth - RRDRight) ) * DivEpoch / RRDImgUsable * RightFactor);
+
+
     $('zoom').src = myURL + '?displaymode=a;start=' + StartEpoch + ';end=' + EndEpoch + ';target=' + Target;

     myCropper.setParams();


