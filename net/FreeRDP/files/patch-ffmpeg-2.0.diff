--- channels/tsmf/client/ffmpeg/tsmf_ffmpeg.c.orig	2013-07-10 01:00:21.000000000 -0700
+++ channels/tsmf/client/ffmpeg/tsmf_ffmpeg.c	2013-08-12 22:26:28.000000000 -0700
@@ -43,12 +43,20 @@
 #define AVMEDIA_TYPE_AUDIO 1
 #endif
 
+#ifndef AVCODEC_MAX_AUDIO_FRAME_SIZE
+#define AVCODEC_MAX_AUDIO_FRAME_SIZE 192000 // 1 second of 48khz 32bit audio
+#endif
+
 typedef struct _TSMFFFmpegDecoder
 {
 	ITSMFDecoder iface;
 
 	int media_type;
+#if LIBAVCODEC_VERSION_MAJOR > 54
+	enum AVCodecID codec_id;
+#else
 	enum CodecID codec_id;
+#endif
 	AVCodecContext* codec_context;
 	AVCodec* codec;
 	AVFrame* frame;
@@ -99,8 +107,12 @@
 	mdecoder->codec_context->block_align = media_type->BlockAlign;
 
 #ifdef AV_CPU_FLAG_SSE2
+#if LIBAVCODEC_VERSION_MAJOR < 55
 	mdecoder->codec_context->dsp_mask = AV_CPU_FLAG_SSE2 | AV_CPU_FLAG_MMX2;
 #else
+	av_set_cpu_flags_mask(AV_CPU_FLAG_SSE2 | AV_CPU_FLAG_MMX2); 
+#endif
+#else
 #if LIBAVCODEC_VERSION_MAJOR < 53
 	mdecoder->codec_context->dsp_mask = FF_MM_SSE2 | FF_MM_MMXEXT;
 #else
