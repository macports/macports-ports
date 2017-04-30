diff --git a/src/MemoryX.h b/src/MemoryX.h
index 1eb296e307141305018799636edd9ad1fee89159..df809bc79c08aff4a2930d88c021f09e337d0067 100644
--- a/src/MemoryX.h
+++ b/src/MemoryX.h
@@ -3,6 +3,7 @@
 
 // C++ standard header <memory> with a few extensions
 #include <memory>
+#include <stdlib.h>
 
 #ifndef safenew
 #define safenew new
diff --git a/src/Mix.cpp b/src/Mix.cpp
index a16ca05e25f3095230b0c507293a98493eb0a262..7abf44da3cb39b301b50927494693957471af12e 100644
--- a/src/Mix.cpp
+++ b/src/Mix.cpp
@@ -255,7 +255,7 @@ Mixer::Mixer(const WaveTrackConstArray &inputTracks,
    , mQueueMaxLen{ 65536 }
    , mSampleQueue{ mNumInputTracks, mQueueMaxLen }
 
-   , mNumChannels{ static_cast<size_t>(numOutChannels) }
+   , mNumChannels{ static_cast<unsigned>(numOutChannels) }
    , mGains{ mNumChannels }
 
    , mMayThrow{ mayThrow }
