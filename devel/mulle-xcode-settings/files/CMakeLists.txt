# Generated on 2017-10-5 13:05:21 by version 0.6.5 of mulle-xcode-to-cmake
# Command line:
#    mulle-xcode-to-cmake -2 export mulle-xcode-settings.xcodeproj

project( mulle-xcode-settings)

cmake_minimum_required (VERSION 3.4)

#
# mulle-bootstrap environment
#

# check if compiling with mulle-bootstrap (works since 2.6)

if( NOT MULLE_BOOTSTRAP_VERSION)
  include_directories( BEFORE SYSTEM
dependencies/include
addictions/include
)

  set( CMAKE_FRAMEWORK_PATH
dependencies/Frameworks
addictions/Frameworks
${CMAKE_FRAMEWORK_PATH}
)

  set( CMAKE_LIBRARY_PATH
dependencies/lib
addictions/lib
${CMAKE_LIBRARY_PATH}
)

set( DEPENDENCIES_DIR dependencies)
set( ADDICTIONS_DIR addictions)

endif()

#
# Platform specific definitions
#

if( APPLE)
   # # CMAKE_OSX_SYSROOT must be set for CMAKE_OSX_DEPLOYMENT_TARGET (cmake bug)
   # if( NOT CMAKE_OSX_SYSROOT)
   #    set( CMAKE_OSX_SYSROOT "/" CACHE STRING "SDK for OSX" FORCE)   # means current OS X
   # endif()
   #
   # # baseline set to 10.6 for rpath
   # if( NOT CMAKE_OSX_DEPLOYMENT_TARGET)
   #   set(CMAKE_OSX_DEPLOYMENT_TARGET "10.6" CACHE STRING "Deployment target for OSX" FORCE)
   # endif()

   set( CMAKE_POSITION_INDEPENDENT_CODE FALSE)

   set( BEGIN_ALL_LOAD "-all_load")
   set( END_ALL_LOAD)
else()
   set( CMAKE_POSITION_INDEPENDENT_CODE TRUE)

   if( WIN32)
   # windows
   else()
   # linux / gcc
      set( BEGIN_ALL_LOAD "-Wl,--whole-archive")
      set( END_ALL_LOAD "-Wl,--no-whole-archive")
   endif()
endif()

##
## Produce CMakeSourcesAndHeaders.txt with:
##   mulle-xcode-to-cmake -t 'mulle-xcode-settings' -t 'mullepbx' sexport > CMakeSourcesAndHeaders.txt
##

include( CMakeSourcesAndHeaders.txt)

# uncomment this for mulle-objc to search libraries first
# set( CMAKE_FIND_FRAMEWORK "LAST")

set( MULLEPBX_LIBRARY mullepbx)
message( STATUS "MULLEPBX_LIBRARY is ${MULLEPBX_LIBRARY}")

set( MULLE_XCODE_SETTINGS_STATIC_DEPENDENCIES
${MULLEPBX_LIBRARY}
)

find_library( FOUNDATION_LIBRARY Foundation)
message( STATUS "FOUNDATION_LIBRARY is ${FOUNDATION_LIBRARY}")

set( MULLE_XCODE_SETTINGS_DEPENDENCIES
${FOUNDATION_LIBRARY}
)

# uncomment this for mulle-objc to search libraries first
# set( CMAKE_FIND_FRAMEWORK "LAST")


##
## mulle-xcode-settings
##

add_executable( mulle-xcode-settings 
${MULLE_XCODE_SETTINGS_SOURCES}
${MULLE_XCODE_SETTINGS_PUBLIC_HEADERS}
${MULLE_XCODE_SETTINGS_PROJECT_HEADERS}
${MULLE_XCODE_SETTINGS_PRIVATE_HEADERS}
${MULLE_XCODE_SETTINGS_RESOURCES}
)

target_include_directories( mulle-xcode-settings
   PUBLIC
      src/PBXReading
      src/PBXWriting
)

add_dependencies( mulle-xcode-settings mullepbx)

target_link_libraries( mulle-xcode-settings
${BEGIN_ALL_LOAD}
${MULLE_XCODE_SETTINGS_STATIC_DEPENDENCIES}
${END_ALL_LOAD}
${MULLE_XCODE_SETTINGS_DEPENDENCIES}
)


##
## mullepbx
##

add_library( mullepbx STATIC
${MULLEPBX_SOURCES}
${MULLEPBX_PUBLIC_HEADERS}
${MULLEPBX_PROJECT_HEADERS}
${MULLEPBX_PRIVATE_HEADERS}
${MULLEPBX_RESOURCES}
)

target_include_directories( mullepbx
   PUBLIC
      src/PBXReading
      src/PBXWriting
)

install( TARGETS mullepbx DESTINATION "lib")
install( FILES ${MULLEPBX_PUBLIC_HEADERS} DESTINATION "include/mullepbx")
install( TARGETS mulle-xcode-settings DESTINATION "bin")
