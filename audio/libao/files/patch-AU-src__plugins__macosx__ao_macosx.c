--- src/plugins/macosx/ao_macosx.c.orig	2004-11-09 09:20:26.000000000 +0100
+++ src/plugins/macosx/ao_macosx.c	2007-11-30 13:37:22.000000000 +0100
@@ -29,7 +29,8 @@
   audio samples rather than having them pushed at it (which is nice
   when you are wanting to do good buffering of audio).  */
 
-#include <CoreAudio/AudioHardware.h>
+#include <AudioUnit/AudioUnit.h>
+#include <AudioUnit/AUNTComponent.h>
 #include <stdio.h>
 #include <pthread.h>
 
@@ -39,8 +39,7 @@
 // Set this to 1 to see FIFO debugging messages
 #define DEBUG_PIPE 0
 
-//#define BUFFER_COUNT (323)
-#define BUFFER_COUNT (2)
+#define DEFAULT_BUFFER_TIME (250);
 
 #ifndef MIN
 #define MIN(a,b) ((a) < (b) ? (a) : (b))
@@ -52,9 +51,9 @@
 static ao_info ao_macosx_info =
 {
 	AO_TYPE_LIVE,
-	"MacOS X output",
-	"macosx",
-	"Timothy J. Wood <tjw@omnigroup.com>",
+	"MacOS X AUHAL output",
+	"macosxau",
+	"Michael Guntsche <mike@it-loops.com>",
 	"",
 	AO_FMT_NATIVE,
 	30,
@@ -65,374 +64,409 @@
 
 typedef struct ao_macosx_internal
 {
-    // Stuff describing the CoreAudio device
-    AudioDeviceID                outputDeviceID;
-    AudioStreamBasicDescription  outputStreamBasicDescription;
-    
-    // The amount of data CoreAudio wants each time it calls our IO function
-    UInt32                       outputBufferByteCount;
-    
-    // Keep track of whether the output stream has actually been started/stopped
-    Boolean                      started;
-    Boolean                      isStopping;
-    
-    // Synchronization objects between the CoreAudio thread and the enqueuing thread
-    pthread_mutex_t              mutex;
-    pthread_cond_t               condition;
-
-    // Our internal queue of samples waiting to be consumed by CoreAudio
-    void                        *buffer;
-    unsigned int                 bufferByteCount;
-    unsigned int                 firstValidByteOffset;
-    unsigned int                 validByteCount;
-    
-    // Temporary debugging state
-    unsigned int bytesQueued;
-    unsigned int bytesDequeued;
+  // Stuff describing the CoreAudio device
+  AudioUnit                    outputAudioUnit;
+
+  // Keep track of whether the output stream has actually been started/stopped
+  Boolean                      started;
+  Boolean                      isStopping;
+
+  // Synchronization objects between the CoreAudio thread and the enqueuing thread
+  pthread_mutex_t              mutex;
+  pthread_cond_t               condition;
+
+  // Our internal queue of samples waiting to be consumed by CoreAudio
+  void                        *buffer;
+  unsigned int                 bufferByteCount;
+  unsigned int                 firstValidByteOffset;
+  unsigned int                 validByteCount;
+
+  unsigned int                 buffer_time;
+  // Temporary debugging state
+  unsigned int bytesQueued;
+  unsigned int bytesDequeued;
 } ao_macosx_internal;
 
 // The function that the CoreAudio thread calls when it wants more data
-static OSStatus audioDeviceIOProc(AudioDeviceID inDevice, const AudioTimeStamp *inNow, const AudioBufferList *inInputData, const AudioTimeStamp *inInputTime, AudioBufferList *outOutputData, const AudioTimeStamp *inOutputTime, void *inClientData);
+static OSStatus     audioCallback (void                             *inRefCon, 
+								   AudioUnitRenderActionFlags      inActionFlags,
+								   const AudioTimeStamp            *inTimeStamp, 
+								   UInt32                          inBusNumber, 
+								   AudioBuffer                     *ioData)
+
+{
+  ao_macosx_internal *internal = (ao_macosx_internal *)inRefCon;
+  short *sample;
+  unsigned int validByteCount;
+  unsigned char *outBuffer;
+  unsigned int bytesToCopy, samplesToCopy, firstFrag;
+
+
+
+  // Find the first valid frame and the number of valid frames
+  pthread_mutex_lock(&internal->mutex);
+
+
+  bytesToCopy = ioData->mDataByteSize;
+  firstFrag = bytesToCopy;
+  validByteCount = internal->validByteCount;
+  outBuffer = ioData->mData;
+
+
+#if DEBUG_PIPE
+  fprintf(stderr,"BTC: %i Valid: %i\n",bytesToCopy,validByteCount);
+#endif
+
+  if (validByteCount < bytesToCopy && !internal->isStopping) {
+    // Not enough data ... let it build up a bit more before we start copying stuff over.
+    // If we are stopping, of course, we should just copy whatever we have.
+    // This also happens if an application pauses output.
+    inActionFlags = kAudioUnitRenderAction_OutputIsSilence;
+    memset(outBuffer, 0, ioData->mDataByteSize);
+    pthread_mutex_unlock(&internal->mutex);
+    return 0;
+  }
+
+
+  bytesToCopy = MIN(bytesToCopy, validByteCount);
+  sample = internal->buffer + internal->firstValidByteOffset;
+  samplesToCopy = bytesToCopy / sizeof(*sample);
+
+  /* Check if we habe a wrap around in the ring buffer
+   * If yes then find out how many bytes we have */
+  if (internal->firstValidByteOffset + bytesToCopy > internal->bufferByteCount) 
+    firstFrag = internal->bufferByteCount - internal->firstValidByteOffset;
+
+  #if DEBUG_PIPE
+  fprintf(stderr, "IO: firstValid=%d valid=%d toCopy=%d queued=%d dequeued=%d sample=0x%08x\n",
+      
+      internal->firstValidByteOffset, internal->validByteCount, samplesToCopy, internal->bytesQueued, internal->bytesDequeued, sample);
+  #endif
+
+  internal->validByteCount -= bytesToCopy;
+  internal->firstValidByteOffset = (internal->firstValidByteOffset + bytesToCopy) % internal->bufferByteCount;
+
+  /* If we have a wraparound first copy the remaining bytes off the end
+   * and then the rest from the beginning of the ringbuffer */
+  if (firstFrag < bytesToCopy) {
+    memcpy(outBuffer,sample,firstFrag);
+    memcpy(outBuffer+firstFrag,internal->buffer,bytesToCopy-firstFrag);
+  }
+  else {
+    memcpy(outBuffer,sample,bytesToCopy);
+  }
+
+  pthread_mutex_unlock(&internal->mutex);
+  pthread_cond_signal(&internal->condition);
+
+  return 0;
+}
+
+
+
 
 int ao_plugin_test()
 {
 	
-	if (/* FIXME */ 0 )
-		return 0; /* Cannot use this plugin with default parameters */
-	else {
-		return 1; /* This plugin works in default mode */
-	}
+  if (/* FIXME */ 0 )
+    return 0; /* Cannot use this plugin with default parameters */
+  else {
+    return 1; /* This plugin works in default mode */
+  }
 }
 
 ao_info *ao_plugin_driver_info(void)
 {
-	return &ao_macosx_info;
+  return &ao_macosx_info;
 }
 
 
 int ao_plugin_device_init(ao_device *device)
 {
-	ao_macosx_internal *internal;
+  ao_macosx_internal *internal;
 
-	internal = (ao_macosx_internal *) malloc(sizeof(ao_macosx_internal));
+  internal = (ao_macosx_internal *) malloc(sizeof(ao_macosx_internal));
 
-	if (internal == NULL)	
-		return 0; /* Could not initialize device memory */
-	
+  if (internal == NULL)	
+    return 0; /* Could not initialize device memory */
 
-	
-	device->internal = internal;
+  internal->buffer_time = DEFAULT_BUFFER_TIME;
+  internal->started = false;
+  internal->isStopping = false;
 
-	return 1; /* Memory alloc successful */
-}
+  device->internal = internal;
 
+  return 1; /* Memory alloc successful */
+  }
 
-int ao_plugin_set_option(ao_device *device, const char *key, const char *value)
-{
-	ao_macosx_internal *internal = (ao_macosx_internal *) device->internal;
 
-	/* No options */
-
-	return 1;
+int ao_plugin_set_option(ao_device *device, const char *key, const char *value)
+  {
+  ao_macosx_internal *internal = (ao_macosx_internal *) device->internal;
+  int buffer;
+
+  if (!strcmp(key,"buffer_time")) {
+    buffer = atoi(value);
+    if (buffer < 100) {
+      fprintf(stderr,"Buffer time clipped to 100ms\n");
+      buffer = DEFAULT_BUFFER_TIME;
+    }
+    internal->buffer_time = buffer;
+  }
+  
+  /* No options */
+  return 1;
 }
 
 
 int ao_plugin_open(ao_device *device, ao_sample_format *format)
 {
-    ao_macosx_internal *internal = (ao_macosx_internal *) device->internal;
-    OSStatus status;
-    UInt32 propertySize;
-    int rc;
-    
-    if (format->rate != 44100) {
-        fprintf(stderr, "ao_macosx_open: Only support 44.1kHz right now\n");
-        return 0;
-    }
-    
-    if (format->channels != 2) {
-        fprintf(stderr, "ao_macosx_open: Only two channel audio right now\n");
-        return 0;
-    }
+  ao_macosx_internal *internal = (ao_macosx_internal *) device->internal;
 
-    propertySize = sizeof(internal->outputDeviceID);
-    status = AudioHardwareGetProperty(kAudioHardwarePropertyDefaultOutputDevice, &propertySize, &(internal->outputDeviceID));
-    if (status) {
-        fprintf(stderr, "ao_macosx_open: AudioHardwareGetProperty returned %d\n", (int)status);
-	return 0;
-    }
-    
-    if (internal->outputDeviceID == kAudioDeviceUnknown) {
-        fprintf(stderr, "ao_macosx_open: AudioHardwareGetProperty: outputDeviceID is kAudioDeviceUnknown\n");
-	return 0;
-    }
-    
-    propertySize = sizeof(internal->outputStreamBasicDescription);
-    status = AudioDeviceGetProperty(internal->outputDeviceID, 0, false, kAudioDevicePropertyStreamFormat, &propertySize, &internal->outputStreamBasicDescription);
-    if (status) {
-        fprintf(stderr, "ao_macosx_open: AudioDeviceGetProperty returned %d when getting kAudioDevicePropertyStreamFormat\n", (int)status);
-	return 0;
-    }
+  OSStatus result = noErr;
+  Component comp;
+  ComponentDescription desc;
+  struct AudioUnitInputCallback callback;
+  AudioStreamBasicDescription requestedDesc;
+  UInt32 i_param_size;
+  int rc;
+
+
+  /* Setup a AudioStreamBasicDescription with the requested format */
+  requestedDesc.mFormatID = kAudioFormatLinearPCM;
+  requestedDesc.mFormatFlags = kAudioFormatFlagIsPacked;
+
+	if (ao_is_big_endian())
+		requestedDesc.mFormatFlags |= kAudioFormatFlagIsBigEndian;
+
+  if (format->bits > 8)
+    requestedDesc.mFormatFlags |= kAudioFormatFlagIsSignedInteger;
+
+  requestedDesc.mChannelsPerFrame = format->channels;
+  requestedDesc.mSampleRate = format->rate;
+  requestedDesc.mBitsPerChannel = format->bits;
+  requestedDesc.mFramesPerPacket = 1;
+  requestedDesc.mBytesPerFrame = requestedDesc.mBitsPerChannel * requestedDesc.mChannelsPerFrame / 8;
+  requestedDesc.mBytesPerPacket = requestedDesc.mBytesPerFrame * requestedDesc.mFramesPerPacket;
+
+  /* Locate the default output audio unit */
+  desc.componentType = kAudioUnitComponentType;
+  desc.componentSubType = kAudioUnitSubType_Output;
+  desc.componentManufacturer = kAudioUnitID_DefaultOutput;
+  desc.componentFlags = 0;
+  desc.componentFlagsMask = 0;
+
+
+  comp = FindNextComponent (NULL, &desc);
+  if (comp == NULL) {
+    fprintf (stderr,"Failed to start CoreAudio: FindNextComponent returned NULL");
+    return 0;
+  }
 
-    fprintf(stderr, "hardware format...\n");
-    fprintf(stderr, "%f mSampleRate\n", internal->outputStreamBasicDescription.mSampleRate);
-    fprintf(stderr, "%c%c%c%c mFormatID\n", (int)(internal->outputStreamBasicDescription.mFormatID & 0xff000000) >> 24,
-                                            (int)(internal->outputStreamBasicDescription.mFormatID & 0x00ff0000) >> 16,
-                                            (int)(internal->outputStreamBasicDescription.mFormatID & 0x0000ff00) >>  8,
-                                            (int)(internal->outputStreamBasicDescription.mFormatID & 0x000000ff) >>  0);
-    fprintf(stderr, "%5d mBytesPerPacket\n", (int)internal->outputStreamBasicDescription.mBytesPerPacket);
-    fprintf(stderr, "%5d mFramesPerPacket\n", (int)internal->outputStreamBasicDescription.mFramesPerPacket);
-    fprintf(stderr, "%5d mBytesPerFrame\n", (int)internal->outputStreamBasicDescription.mBytesPerFrame);
-    fprintf(stderr, "%5d mChannelsPerFrame\n", (int)internal->outputStreamBasicDescription.mChannelsPerFrame);
-
-    if (internal->outputStreamBasicDescription.mFormatID != kAudioFormatLinearPCM) {
-        fprintf(stderr, "ao_macosx_open: Default Audio Device doesn't support Linear PCM!\n");
-	return 0;
-    }
+  /* Open & initialize the default output audio unit */
+    result = OpenAComponent (comp, &internal->outputAudioUnit);
+  if (result) 
+    fprintf(stderr,"Comp error\n");
+  result = AudioUnitInitialize (internal->outputAudioUnit);
+  if (result) 
+    fprintf(stderr,"Init error\n");
+
+  /* Set the audio callback */
+  callback.inputProc = audioCallback;
+  callback.inputProcRefCon = internal;
+  result = AudioUnitSetProperty (internal->outputAudioUnit, 
+      kAudioUnitProperty_SetInputCallback, 
+      kAudioUnitScope_Input, 
+      0,
+      &callback, 
+      sizeof(callback));
 
-    propertySize = sizeof(internal->outputBufferByteCount);
-    
-    internal->outputBufferByteCount = 8192;
-    status = AudioDeviceSetProperty(internal->outputDeviceID, 0, 0, false, kAudioDevicePropertyBufferSize,
-        propertySize, &internal->outputBufferByteCount);
-        
-    status = AudioDeviceGetProperty(internal->outputDeviceID, 0, false, kAudioDevicePropertyBufferSize, &propertySize, &internal->outputBufferByteCount);
-    if (status) {
-        fprintf(stderr, "ao_macosx_open: AudioDeviceGetProperty returned %d when getting kAudioDevicePropertyBufferSize\n", (int)status);
-	return 0;
-    }
+  if (result) {
 
-    fprintf(stderr, "%5d outputBufferByteCount\n", (int)internal->outputBufferByteCount);
+    fprintf(stderr,"Callback %i\n",result);
+    return 0;
+  }
 
-    // It appears that AudioDeviceGetProperty lies about this property in DP4
-    // Set the actual value
-    //internal->outputBufferByteCount = 32768;
-
-    // Set the IO proc that CoreAudio will call when it needs data, but don't start
-    // the stream yet.
-    internal->started = false;
-    status = AudioDeviceAddIOProc(internal->outputDeviceID, audioDeviceIOProc, internal);
-    if (status) {
-        fprintf(stderr, "ao_macosx_open: AudioDeviceAddIOProc returned %d\n", (int)status);
-	return 0;
-    }
 
-    rc = pthread_mutex_init(&internal->mutex, NULL);
-    if (rc) {
-        fprintf(stderr, "ao_macosx_open: pthread_mutex_init returned %d\n", rc);
-	return 0;
-    }
-    
-    rc = pthread_cond_init(&internal->condition, NULL);
-    if (rc) {
-        fprintf(stderr, "ao_macosx_open: pthread_cond_init returned %d\n", rc);
-	return 0;
-    }
+  /* Set the input format of the audio unit. */
     
-    /* Since we don't know how big to make the buffer until we open the device
-       we allocate the buffer here instead of ao_plugin_device_init() */
-    internal->bufferByteCount = BUFFER_COUNT * internal->outputBufferByteCount;
-    internal->firstValidByteOffset = 0;
-    internal->validByteCount = 0;
-    internal->buffer = malloc(internal->bufferByteCount);
-    memset(internal->buffer, 0, internal->bufferByteCount);
-    if (!internal->buffer) {
-        fprintf(stderr, "ao_macosx_open: Unable to allocate queue buffer.\n");
-	return 0;
-    }
+  result = AudioUnitSetProperty (internal->outputAudioUnit,
+                   kAudioUnitProperty_StreamFormat,
+                   kAudioUnitScope_Input,
+                   0,
+                   &requestedDesc,
+                   sizeof(AudioStreamBasicDescription));
 
-    /* initialize debugging state */
-    internal->bytesQueued = 0;
-    internal->bytesDequeued = 0;
-    
-    device->driver_byte_format = AO_FMT_NATIVE;
+  if (result) {
+
+    fprintf(stderr,"Output %i\n",result);
+    return 0;
+  }
+
+  rc = pthread_mutex_init(&internal->mutex, NULL);
+  if (rc) {
+    fprintf(stderr, "ao_macosx_open: pthread_mutex_init returned %d\n", rc);
+    return 0;
+  }
+
+  rc = pthread_cond_init(&internal->condition, NULL);
+  if (rc) {
+    fprintf(stderr, "ao_macosx_open: pthread_cond_init returned %d\n", rc);
+    return 0;
+  }
+
+  /* Since we don't know how big to make the buffer until we open the device
+     we allocate the buffer here instead of ao_plugin_device_init() */
+
+  internal->bufferByteCount =  (internal->buffer_time * format->rate / 1000) * (format->channels * format->bits / 8);
+
+  internal->firstValidByteOffset = 0;
+  internal->validByteCount = 0;
+  internal->buffer = malloc(internal->bufferByteCount);
+  memset(internal->buffer, 0, internal->bufferByteCount);
+  if (!internal->buffer) {
+    fprintf(stderr, "ao_macosx_open: Unable to allocate queue buffer.\n");
+    return 0;
+  }
+
+  /* initialize debugging state */
+  internal->bytesQueued = 0;
+  internal->bytesDequeued = 0;
+
+  device->driver_byte_format = AO_FMT_NATIVE;
+
+
+  return 1;
 
-    return 1;
 }
 
 
 int ao_plugin_play(ao_device *device, const char *output_samples, 
 		uint_32 num_bytes)
 {
-    ao_macosx_internal *internal = (ao_macosx_internal *) device->internal;
-    OSStatus status;
+  ao_macosx_internal *internal = (ao_macosx_internal *) device->internal;
+  OSStatus status;
+	int err;
+  unsigned int bytesToCopy;
+  unsigned int firstEmptyByteOffset, emptyByteCount;
 
-#if DEBUG_PIPE
-    fprintf(stderr, "Enqueue: 0x%08x %d bytes\n", output_samples, num_bytes);
-#endif
 
-    while (num_bytes) {
-        unsigned int bytesToCopy;
-        unsigned int firstEmptyByteOffset, emptyByteCount;
-        
-        // Get a consistent set of data about the available space in the queue,
-        // figure out the maximum number of bytes we can copy in this chunk,
-        // and claim that amount of space
-        pthread_mutex_lock(&internal->mutex);
-
-        // Wait until there is some empty space in the queue
-        emptyByteCount = internal->bufferByteCount - internal->validByteCount;
-        while (emptyByteCount == 0) {
-            pthread_cond_wait(&internal->condition, &internal->mutex);
-            emptyByteCount = internal->bufferByteCount - internal->validByteCount;
-        }
-
-        // Compute the offset to the first empty byte and the maximum number of
-        // bytes we can copy given the fact that the empty space might wrap
-        // around the end of the queue.
-        firstEmptyByteOffset = (internal->firstValidByteOffset + internal->validByteCount) % internal->bufferByteCount;
-        if (firstEmptyByteOffset + emptyByteCount > internal->bufferByteCount)
-            bytesToCopy = MIN(num_bytes, internal->bufferByteCount - firstEmptyByteOffset);
-        else
-            bytesToCopy = MIN(num_bytes, emptyByteCount);
+  while (num_bytes) {
+		
+    // Get a consistent set of data about the available space in the queue,
+    // figure out the maximum number of bytes we can copy in this chunk,
+    // and claim that amount of space
+    pthread_mutex_lock(&internal->mutex);
+
+    // Wait until there is some empty space in the queue
+    emptyByteCount = internal->bufferByteCount - internal->validByteCount;
+    while (emptyByteCount == 0) {
+      err = pthread_cond_wait(&internal->condition, &internal->mutex);
+      if (err)
+        fprintf(stderr,"Whatever: %i\n",err);
+      emptyByteCount = internal->bufferByteCount - internal->validByteCount;
+    }
+
+    // Compute the offset to the first empty byte and the maximum number of
+    // bytes we can copy given the fact that the empty space might wrap
+    // around the end of the queue.
+    firstEmptyByteOffset = (internal->firstValidByteOffset + internal->validByteCount) % internal->bufferByteCount;
+    if (firstEmptyByteOffset + emptyByteCount > internal->bufferByteCount)
+      bytesToCopy = MIN(num_bytes, internal->bufferByteCount - firstEmptyByteOffset);
+    else
+      bytesToCopy = MIN(num_bytes, emptyByteCount);
+
+    // Copy the bytes and get ready for the next chunk, if any
+  #if DEBUG_PIPE
+    fprintf(stderr, "Enqueue:\tdst = 0x%08x src=0x%08x count=%d\n",
+        internal->buffer + firstEmptyByteOffset, output_samples, bytesToCopy);
+  #endif
+
+    memcpy(internal->buffer + firstEmptyByteOffset, output_samples, bytesToCopy);
+
+
+
+    num_bytes -= bytesToCopy;
+    output_samples += bytesToCopy;
+    internal->validByteCount += bytesToCopy;
+
+    internal->bytesQueued += bytesToCopy;
+
+    pthread_mutex_unlock(&internal->mutex);
+
+    // We have to wait to start the device until we have some data queued.
+    // It might be better to wait until we have some minimum amount of data
+    // larger than whatever blob got enqueued here, but if we had a short
+    // stream, we'd have to make sure that ao_macosx_close() would start
+    // AND stop the stream when it had finished.  Yuck.  If the first
+    // blob that is passed to us is large enough (and the caller passes
+    // data quickly enough, this shouldn't be a problem. 
+  #if 1
+    if (!internal->started) {
+      internal->started = true;
+      if(AudioOutputUnitStart(internal->outputAudioUnit)) fprintf(stderr,"asdfsadf\n");
 
-        // Copy the bytes and get ready for the next chunk, if any
-#if DEBUG_PIPE
-        fprintf(stderr, "Enqueue:\tdst = 0x%08x src=0x%08x count=%d\n",
-                internal->buffer + firstEmptyByteOffset, output_samples, bytesToCopy);
-#endif
-                
-        memcpy(internal->buffer + firstEmptyByteOffset, output_samples, bytesToCopy);
-        /*{
-            unsigned int i;
-            static unsigned char bufferIndex;
-            
-            bufferIndex++;
-            memset(internal->buffer + firstEmptyByteOffset, bufferIndex, bytesToCopy);
-        }*/
-        
-        num_bytes -= bytesToCopy;
-        output_samples += bytesToCopy;
-        internal->validByteCount += bytesToCopy;
-        
-        internal->bytesQueued += bytesToCopy;
-        
-        //fprintf(stderr, "Copy: %d bytes, %d bytes left\n", bytesToCopy, internal->availableByteCount);
-        pthread_mutex_unlock(&internal->mutex);
-        
-        // We have to wait to start the device until we have some data queued.
-        // It might be better to wait until we have some minimum amount of data
-        // larger than whatever blob got enqueued here, but if we had a short
-        // stream, we'd have to make sure that ao_macosx_close() would start
-        // AND stop the stream when it had finished.  Yuck.  If the first
-        // blob that is passed to us is large enough (and the caller passes
-        // data quickly enough, this shouldn't be a problem. 
-#if 1
-        if (!internal->started) {
-            internal->started = true;
-            status = AudioDeviceStart(internal->outputDeviceID, audioDeviceIOProc);
-            if (status) {
-                fprintf(stderr, "ao_macosx_open: AudioDeviceStart returned %d\n", (int)status);
-                
-                // Can we do anything useful here?  The library doesn't expect this call
-                // to be able to fail.
-		return 0;
-            }
-        }
-#endif
     }
+  #endif
+  }
 
-    return 1;
+  return 1;
 }
 
 
 int ao_plugin_close(ao_device *device)
 {
-    ao_macosx_internal *internal = (ao_macosx_internal *) device->internal;
-    OSStatus status;
+  ao_macosx_internal *internal = (ao_macosx_internal *) device->internal;
+  OSStatus status;
+  UInt32 running;
+  UInt32 sizeof_running;
 
-    // Only stop if we ever got started
-    if (internal->started) {
 
-        internal->isStopping = true;
-        
-        // Wait for any pending data to get flushed
-        pthread_mutex_lock(&internal->mutex);
-        while (internal->validByteCount)
-            pthread_cond_wait(&internal->condition, &internal->mutex);
-        pthread_mutex_unlock(&internal->mutex);
-        
-        status = AudioDeviceStop(internal->outputDeviceID, audioDeviceIOProc);
-        if (status) {
-            fprintf(stderr, "ao_macosx_close: AudioDeviceStop returned %d\n", (int)status);
-            return 0;
-        }
+
+  // For some rare cases (using atexit in your program) Coreaudio tears
+  // down the HAL itself, so we do not need to do that here.
+  // We wouldn't get an error if we did, but AO would hang waiting for the AU to flush the buffer
+  /*sizeof_running = sizeof(UInt32);
+  AudioUnitGetProperty(internal->outputAudioUnit, 0, false, kAudioDevicePropertyDeviceIsRunning, &sizeof_running, &running);
+  if (!running) {
+    return 1;
+  }
+  */
+
+  // Only stop if we ever got started
+  if (internal->started) {
+
+    internal->isStopping = true;
+
+    // Wait for any pending data to get flushed
+    /*pthread_mutex_lock(&internal->mutex);
+    while (internal->validByteCount)
+      pthread_cond_wait(&internal->condition, &internal->mutex);
+    pthread_mutex_unlock(&internal->mutex);
+    */
+    status = AudioOutputUnitStop(internal->outputAudioUnit);
+    if (status) {
+      fprintf(stderr, "ao_macosx_close: AudioDeviceStop returned %d\n", (int)status);
+      return 0;
     }
-    
-    status = AudioDeviceRemoveIOProc(internal->outputDeviceID, audioDeviceIOProc);
+    status = AudioUnitUninitialize(internal->outputAudioUnit);
     if (status) {
-        fprintf(stderr, "ao_macosx_close: AudioDeviceRemoveIOProc returned %d\n", (int)status);
-        return 0;
+      fprintf(stderr, "ao_macosx_close: AudioUnitUninitialize returned %d\n", (int)status);
+      return 0;
     }
+  }
 
-    return 1;
+  return 1;
 }
 
 
 void ao_plugin_device_clear(ao_device *device)
 {
-	ao_macosx_internal *internal = (ao_macosx_internal *) device->internal;
+  ao_macosx_internal *internal = (ao_macosx_internal *) device->internal;
 
-	free(internal->buffer);
-	free(internal);
+  free(internal->buffer);
+  free(internal);
 }
 
 
-static OSStatus audioDeviceIOProc(AudioDeviceID inDevice, const AudioTimeStamp *inNow, const AudioBufferList *inInputData, const AudioTimeStamp *inInputTime, AudioBufferList *outOutputData, const AudioTimeStamp *inOutputTime, void *inClientData)
-{
-    ao_macosx_internal *internal = (ao_macosx_internal *)inClientData;
-    short *sample;
-    unsigned int validByteCount;
-    float scale = (0.5f / SHRT_MAX), *outBuffer;
-    unsigned int bytesToCopy, samplesToCopy;
-
-    // Find the first valid frame and the number of valid frames
-    pthread_mutex_lock(&internal->mutex);
-
-    bytesToCopy = internal->outputBufferByteCount/2;
-    validByteCount = internal->validByteCount;
-    outBuffer = (float *)outOutputData->mBuffers[0].mData;
-    
-    if (validByteCount < bytesToCopy && !internal->isStopping) {
-        // Not enough data ... let it build up a bit more before we start copying stuff over.
-        // If we are stopping, of course, we should just copy whatever we have.
-        memset(outBuffer, 0, bytesToCopy);
-        pthread_mutex_unlock(&internal->mutex);
-        return 0;
-    }
-    
-    bytesToCopy = MIN(bytesToCopy, validByteCount);
-    sample = internal->buffer + internal->firstValidByteOffset;
-    samplesToCopy = bytesToCopy / sizeof(*sample);
-
-    internal->bytesDequeued += bytesToCopy;
-
-#if DEBUG_PIPE
-    fprintf(stderr, "IO: outputTime=%f firstValid=%d valid=%d toCopy=%d queued=%d dequeued=%d sample=0x%08x\n",
-            inOutputTime->mSampleTime,
-            internal->firstValidByteOffset, internal->validByteCount, samplesToCopy, internal->bytesQueued, internal->bytesDequeued, sample);
-#endif
-    
-    internal->validByteCount -= bytesToCopy;
-    internal->firstValidByteOffset = (internal->firstValidByteOffset + bytesToCopy) % internal->bufferByteCount;
-    
-    // We don't have to deal with wrapping around in the buffer since the buffer is a
-    // multiple of the output buffer size and we only copy on buffer at a time
-    // (except on the last buffer when we may copy only a partial output buffer).
-#warning On the last buffer, zero out the part of the buffer that does not have valid samples
-    while (samplesToCopy--) {
-        short x = *sample;
-#warning The bytes in the buffer are currently in little endian, but we need big endian.  Supposedly these are going to be host endian at some point and the following line of code can go away.
-/* They will go away now, I think. --- Stan */
-/*        x = ((x & 0xff00) >> 8) | ((x & 0x00ff) << 8); */
-        *outBuffer = x * scale;
-        outBuffer++;
-        sample++;
-    }
-    
-    pthread_mutex_unlock(&internal->mutex);
-    pthread_cond_signal(&internal->condition);
-    
-    return 0;
-}
-
 
