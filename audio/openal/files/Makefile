all: libopenal1.0.0.dylib

libopenal1.0.0.dylib:
	$(CXX) -dynamiclib -install_name $(PREFIX)/lib/$@ -o $@ -L./build/Default -F./build/Default -filelist ./build/al_osx.build/Default/openal.dylib.build/Objects-normal/LinkFileList -framework vecLib -framework CoreAudio -framework CoreFoundation -framework AudioToolbox -framework AudioUnit -framework CoreServices -compatibility_version 1 -current_version 1

