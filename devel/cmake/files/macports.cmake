# Coerce CMake to use the MacPorts ncurses library
# patch __PREFIX__ in the Portfile post-patch stage
set(CURSES_CURSES_LIBRARY "__PREFIX__/lib/libncurses.dylib" CACHE FILEPATH "The Curses Library" FORCE)
