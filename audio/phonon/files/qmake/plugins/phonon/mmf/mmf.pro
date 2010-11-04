# MMF Phonon backend
symbian {
	QT += phonon
	TARGET = phonon_mmf
	PHONON_MMF_DIR = $$QT_SOURCE_TREE/src/3rdparty/phonon/mmf

	# Uncomment the following line in order to use the CDrmPlayerUtility client
	# API for audio playback, rather than CMdaAudioPlayerUtility.
	#CONFIG += phonon_mmf_audio_drm

	phonon_mmf_audio_drm {
		LIBS += -lDrmAudioPlayUtility
		DEFINES += QT_PHONON_MMF_AUDIO_DRM
	} else {
		LIBS += -lmediaclientaudio
	}

	# This is necessary because both epoc32/include and Phonon contain videoplayer.h.
	# By making /epoc32/include the first SYSTEMINCLUDE, we ensure that
	# '#include <videoplayer.h>' picks up the Symbian header, as intended.
	PREPEND_INCLUDEPATH = /epoc32/include

	PREPEND_INCLUDEPATH += $$QT_SOURCE_TREE/src/3rdparty

	INCLUDEPATH += $$MW_LAYER_SYSTEMINCLUDE

	HEADERS +=                                           \
			   $$PHONON_MMF_DIR/abstractaudioeffect.h    \
			   $$PHONON_MMF_DIR/abstractmediaplayer.h    \
			   $$PHONON_MMF_DIR/abstractplayer.h         \
			   $$PHONON_MMF_DIR/abstractvideooutput.h    \
			   $$PHONON_MMF_DIR/abstractvideoplayer.h    \
			   $$PHONON_MMF_DIR/audioequalizer.h         \
			   $$PHONON_MMF_DIR/audiooutput.h            \
			   $$PHONON_MMF_DIR/audioplayer.h            \
			   $$PHONON_MMF_DIR/backend.h                \
			   $$PHONON_MMF_DIR/bassboost.h              \
			   $$PHONON_MMF_DIR/defs.h                   \
			   $$PHONON_MMF_DIR/dummyplayer.h            \
			   $$PHONON_MMF_DIR/effectfactory.h          \
			   $$PHONON_MMF_DIR/effectparameter.h        \
			   $$PHONON_MMF_DIR/environmentalreverb.h    \
			   $$PHONON_MMF_DIR/loudness.h               \
			   $$PHONON_MMF_DIR/mediaobject.h            \
			   $$PHONON_MMF_DIR/mmf_medianode.h          \
			   $$PHONON_MMF_DIR/stereowidening.h         \
			   $$PHONON_MMF_DIR/objectdump.h             \
			   $$PHONON_MMF_DIR/objectdump_symbian.h     \
			   $$PHONON_MMF_DIR/objecttree.h             \
			   $$PHONON_MMF_DIR/utils.h                  \
			   $$PHONON_MMF_DIR/videowidget.h

	SOURCES +=                                           \
			   $$PHONON_MMF_DIR/abstractaudioeffect.cpp  \
			   $$PHONON_MMF_DIR/abstractmediaplayer.cpp  \
			   $$PHONON_MMF_DIR/abstractplayer.cpp       \
			   $$PHONON_MMF_DIR/audioequalizer.cpp       \
			   $$PHONON_MMF_DIR/audiooutput.cpp          \
			   $$PHONON_MMF_DIR/audioplayer.cpp          \
			   $$PHONON_MMF_DIR/abstractvideooutput.cpp  \
			   $$PHONON_MMF_DIR/abstractvideoplayer.cpp  \
			   $$PHONON_MMF_DIR/backend.cpp              \
			   $$PHONON_MMF_DIR/bassboost.cpp            \
			   $$PHONON_MMF_DIR/dummyplayer.cpp          \
			   $$PHONON_MMF_DIR/effectfactory.cpp        \
			   $$PHONON_MMF_DIR/effectparameter.cpp      \
			   $$PHONON_MMF_DIR/environmentalreverb.cpp  \
			   $$PHONON_MMF_DIR/loudness.cpp             \
			   $$PHONON_MMF_DIR/mediaobject.cpp          \
			   $$PHONON_MMF_DIR/mmf_medianode.cpp        \
			   $$PHONON_MMF_DIR/stereowidening.cpp       \
			   $$PHONON_MMF_DIR/objectdump.cpp           \
			   $$PHONON_MMF_DIR/objectdump_symbian.cpp   \
			   $$PHONON_MMF_DIR/objecttree.cpp           \
			   $$PHONON_MMF_DIR/utils.cpp                \
			   $$PHONON_MMF_DIR/videowidget.cpp

	# Test for whether the build environment supports video rendering to graphics
	# surfaces.
	symbian:exists($${EPOCROOT}epoc32/include/platform/videoplayer2.h) {
		HEADERS +=                                       \
			   $$PHONON_MMF_DIR/videooutput_surface.h    \
			   $$PHONON_MMF_DIR/videoplayer_surface.h
		SOURCES +=                                       \
			   $$PHONON_MMF_DIR/videooutput_surface.cpp  \
			   $$PHONON_MMF_DIR/videoplayer_surface.cpp
		DEFINES += PHONON_MMF_VIDEO_SURFACES
	} else {
		HEADERS +=                                       \
			   $$PHONON_MMF_DIR/ancestormovemonitor.h    \
			   $$PHONON_MMF_DIR/videooutput_dsa.h        \
			   $$PHONON_MMF_DIR/videoplayer_dsa.h
		SOURCES +=                                       \
			   $$PHONON_MMF_DIR/ancestormovemonitor.cpp  \
			   $$PHONON_MMF_DIR/videooutput_dsa.cpp      \
			   $$PHONON_MMF_DIR/videoplayer_dsa.cpp      \
	}

	LIBS += -lcone
	LIBS += -lws32

	# This is only needed for debug builds, but is always linked against.
	LIBS += -lhal

	TARGET.CAPABILITY = all -tcb

	LIBS += -lmediaclientvideo        # For CVideoPlayerUtility
	LIBS += -lcone                    # For CCoeEnv
	LIBS += -lws32                    # For RWindow
	LIBS += -lefsrv                   # For file server
	LIBS += -lapgrfx -lapmime         # For recognizer
	LIBS += -lmmfcontrollerframework  # For CMMFMetaDataEntry
	LIBS += -lmediaclientaudiostream  # For CMdaAudioOutputStream

	# These are for effects.
	LIBS += -lAudioEqualizerEffect -lBassBoostEffect -lDistanceAttenuationEffect -lDopplerBase -lEffectBase -lEnvironmentalReverbEffect -lListenerDopplerEffect -lListenerLocationEffect -lListenerOrientationEffect -lLocationBase -lLoudnessEffect -lOrientationBase -lSourceDopplerEffect -lSourceLocationEffect -lSourceOrientationEffect -lStereoWideningEffect

	# This is needed for having the .qtplugin file properly created on Symbian.
	QTDIR_build:DESTDIR = $$QT_BUILD_TREE/plugins/phonon_backend

	target.path = $$[QT_INSTALL_PLUGINS]/phonon_backend
	INSTALLS += target

	include(../../qpluginbase.pri)

	TARGET.UID3=0x2001E629
}
