# put lua51 include path before macports in case lua 5.2 is installed
CPPPATH = ['__PREFIX__/include/lua-5.1', '__PREFIX__/include']
CPPDEFINES = []
LIBPATH = ['__PREFIX__/lib/lua-5.1', '__PREFIX__/lib']
CCFLAGS = ['-fsigned-char']
LINKFLAGS = ['$__RPATH']
CC = ['__CC__']
CXX = ['__CXX__']
MINGWCPPPATH = []
MINGWLIBPATH = []
