--- src/hostapi/coreaudio/pa_mac_core.c.orig	2007-11-13 13:22:56.000000000 -0800
+++ src/hostapi/coreaudio/pa_mac_core.c	2009-07-16 13:05:49.000000000 -0700
@@ -801,8 +801,8 @@
                                    const double sampleRate,
                                    void *refCon )
 {
-    ComponentDescription desc;
-    Component comp;
+    AudioComponentDescription desc;
+    AudioComponent comp;
     /*An Apple TN suggests using CAStreamBasicDescription, but that is C++*/
     AudioStreamBasicDescription desiredFormat;
     OSStatus result = noErr;
@@ -873,7 +873,7 @@
     desc.componentFlags        = 0;
     desc.componentFlagsMask    = 0;
     /* -- find the component -- */
-    comp = FindNextComponent( NULL, &desc );
+    comp = AudioComponentFindNext( NULL, &desc );
     if( !comp )
     {
        DBUG( ( "AUHAL component not found." ) );
@@ -882,7 +882,7 @@
        return paUnanticipatedHostError;
     }
     /* -- open it -- */
-    result = OpenAComponent( comp, audioUnit );
+    result = AudioComponentInstanceNew( comp, audioUnit );
     if( result )
     {
        DBUG( ( "Failed to open AUHAL component." ) );
@@ -1224,7 +1224,7 @@
 #undef ERR_WRAP
 
     error:
-       CloseComponent( *audioUnit );
+       AudioComponentInstanceDispose( *audioUnit );
        *audioUnit = NULL;
        if( result )
           return PaMacCore_SetError( result, line, 1 );
@@ -2146,13 +2146,13 @@
                                              xrunCallback );
        if( stream->outputUnit && stream->outputUnit != stream->inputUnit ) {
           AudioUnitUninitialize( stream->outputUnit );
-          CloseComponent( stream->outputUnit );
+          AudioComponentInstanceDispose( stream->outputUnit );
        }
        stream->outputUnit = NULL;
        if( stream->inputUnit )
        {
           AudioUnitUninitialize( stream->inputUnit );
-          CloseComponent( stream->inputUnit );
+          AudioComponentInstanceDispose( stream->inputUnit );
           stream->inputUnit = NULL;
        }
        if( stream->inputRingBuffer.buffer )
@@ -2211,12 +2211,12 @@
 
 // it's not clear from appl's docs that this really waits
 // until all data is flushed.
-static ComponentResult BlockWhileAudioUnitIsRunning( AudioUnit audioUnit, AudioUnitElement element )
+static OSStatus BlockWhileAudioUnitIsRunning( AudioUnit audioUnit, AudioUnitElement element )
 {
     Boolean isRunning = 1;
     while( isRunning ) {
        UInt32 s = sizeof( isRunning );
-       ComponentResult err = AudioUnitGetProperty( audioUnit, kAudioOutputUnitProperty_IsRunning, kAudioUnitScope_Global, element,  &isRunning, &s );
+       OSStatus err = AudioUnitGetProperty( audioUnit, kAudioOutputUnitProperty_IsRunning, kAudioUnitScope_Global, element,  &isRunning, &s );
        if( err )
           return err;
        Pa_Sleep( 100 );
