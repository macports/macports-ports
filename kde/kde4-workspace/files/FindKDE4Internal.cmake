# - Find the KDE4 include and library dirs, KDE preprocessors and define a some macros
#
# This module defines the following variables:
#
#  KDE4_FOUND               - set to TRUE if everything required for building KDE software has been found
#
#  KDE4_DEFINITIONS         - compiler definitions required for compiling KDE software
#  KDE4_INCLUDE_DIR         - the KDE 4 include directory
#  KDE4_INCLUDES            - all include directories required for KDE, i.e.
#                             KDE4_INCLUDE_DIR, but also the Qt4 include directories
#                             and other platform specific include directories
#  KDE4_LIB_DIR             - the directory where the KDE libraries are installed,
#                             intended to be used with LINK_DIRECTORIES(). In general, this is not necessary.
#  KDE4_LIBEXEC_INSTALL_DIR - the directory where libexec executables from kdelibs are installed
#  KDE4_BIN_INSTALL_DIR     - the directory where executables from kdelibs are installed
#  KDE4_SBIN_INSTALL_DIR    - the directory where system executables from kdelibs are installed
#  KDE4_DATA_INSTALL_DIR    - the parent directory where kdelibs applications install their data
#  KDE4_HTML_INSTALL_DIR    - the directory where HTML documentation from kdelibs is installed
#  KDE4_CONFIG_INSTALL_DIR  - the directory where config files from kdelibs are installed
#  KDE4_ICON_INSTALL_DIR    - the directory where icons from kdelibs are
#  KDE4_IMPORTS_INSTALL_DIR - the directory where imports from kdelibs are
#  KDE4_KCFG_INSTALL_DIR    - the directory where kconfig files from kdelibs are installed
#  KDE4_LOCALE_INSTALL_DIR  - the directory where translations from kdelibs are installed
#  KDE4_MIME_INSTALL_DIR    - the directory where mimetype desktop files from kdelibs are installed
#  KDE4_SOUND_INSTALL_DIR   - the directory where sound files from kdelibs are installed
#  KDE4_TEMPLATES_INSTALL_DIR     - the directory where templates (Create new file...) from kdelibs are installed
#  KDE4_WALLPAPER_INSTALL_DIR     - the directory where wallpapers from kdelibs are installed
#  KDE4_KCONF_UPDATE_INSTALL_DIR  - the directory where kconf_update files from kdelibs are installed
#  KDE4_AUTOSTART_INSTALL_DIR     - the directory where autostart from kdelibs are installed
#  KDE4_XDG_APPS_INSTALL_DIR      - the XDG apps dir from kdelibs
#  KDE4_XDG_DIRECTORY_INSTALL_DIR - the XDG directory from kdelibs
#  KDE4_SYSCONF_INSTALL_DIR       - the directory where sysconfig files from kdelibs are installed
#  KDE4_MAN_INSTALL_DIR           - the directory where man pages from kdelibs are installed
#  KDE4_INFO_INSTALL_DIR          - the directory where info files from kdelibs are installed
#  KDE4_DBUS_INTERFACES_DIR       - the directory where dbus interfaces from kdelibs are installed
#  KDE4_DBUS_SERVICES_DIR         - the directory where dbus service files from kdelibs are installed
#
# The following variables are defined for the various tools required to
# compile KDE software:
#
#  KDE4_KCFGC_EXECUTABLE    - the kconfig_compiler executable
#  KDE4_AUTOMOC_EXECUTABLE  - the kde4automoc executable, deprecated, use AUTOMOC4_EXECUTABLE instead
#  KDE4_MEINPROC_EXECUTABLE - the meinproc4 executable
#  KDE4_MAKEKDEWIDGETS_EXECUTABLE - the makekdewidgets executable
#
# The following variables point to the location of the KDE libraries,
# but shouldn't be used directly:
#
#  KDE4_KDECORE_LIBRARY     - the kdecore library
#  KDE4_KDEUI_LIBRARY       - the kdeui library
#  KDE4_KIO_LIBRARY         - the kio library
#  KDE4_KPARTS_LIBRARY      - the kparts library
#  KDE4_KUTILS_LIBRARY      - the kutils library
#  KDE4_KEMOTICONS_LIBRARY  - the kemoticons library
#  KDE4_KIDLETIME_LIBRARY   - the kidletime library
#  KDE4_KCMUTILS_LIBRARY    - the kcmutils library
#  KDE4_KPRINTUTILS_LIBRARY - the kprintutils library
#  KDE4_KDE3SUPPORT_LIBRARY - the kde3support library
#  KDE4_KFILE_LIBRARY       - the kfile library
#  KDE4_KHTML_LIBRARY       - the khtml library
#  KDE4_KJS_LIBRARY         - the kjs library
#  KDE4_KJSAPI_LIBRARY      - the kjs public api library
#  KDE4_KNEWSTUFF2_LIBRARY  - the knewstuff2 library
#  KDE4_KNEWSTUFF3_LIBRARY  - the knewstuff3 library
#  KDE4_KDNSSD_LIBRARY      - the kdnssd library
#  KDE4_PHONON_LIBRARY      - the phonon library
#  KDE4_THREADWEAVER_LIBRARY- the threadweaver library
#  KDE4_SOLID_LIBRARY       - the solid library
#  KDE4_KNOTIFYCONFIG_LIBRARY- the knotifyconfig library
#  KDE4_KROSSCORE_LIBRARY   - the krosscore library
#  KDE4_KTEXTEDITOR_LIBRARY - the ktexteditor library
#  KDE4_NEPOMUK_LIBRARY     - the nepomuk library
#  KDE4_PLASMA_LIBRARY      - the plasma library
#  KDE4_KUNITCONVERSION_LIBRARY - the kunitconversion library
#  KDE4_KDEWEBKIT_LIBRARY   - the kdewebkit library
#
#  KDE4_PLASMA_OPENGL_FOUND  - TRUE if the OpenGL support of Plasma has been found, NOTFOUND otherwise
#
# Compared to the variables above, the following variables
# also contain all of the depending libraries, so the variables below
# should be used instead of the ones above:
#
#  KDE4_KDECORE_LIBS          - the kdecore library and all depending libraries
#  KDE4_KDEUI_LIBS            - the kdeui library and all depending libraries
#  KDE4_KIO_LIBS              - the kio library and all depending libraries
#  KDE4_KPARTS_LIBS           - the kparts library and all depending libraries
#  KDE4_KUTILS_LIBS           - the kutils library and all depending libraries
#  KDE4_KEMOTICONS_LIBS       - the kemoticons library and all depending libraries
#  KDE4_KIDLETIME_LIBS        - the kidletime library and all depending libraries
#  KDE4_KCMUTILS_LIBS         - the kcmutils library and all depending libraries
#  KDE4_KPRINTUTILS_LIBS      - the kprintutils library and all depending libraries
#  KDE4_KDE3SUPPORT_LIBS      - the kde3support library and all depending libraries
#  KDE4_KFILE_LIBS            - the kfile library and all depending libraries
#  KDE4_KHTML_LIBS            - the khtml library and all depending libraries
#  KDE4_KJS_LIBS              - the kjs library and all depending libraries
#  KDE4_KJSAPI_LIBS           - the kjs public api library and all depending libraries
#  KDE4_KNEWSTUFF2_LIBS       - the knewstuff2 library and all depending libraries
#  KDE4_KNEWSTUFF3_LIBS       - the knewstuff3 library and all depending libraries
#  KDE4_KDNSSD_LIBS           - the kdnssd library and all depending libraries
#  KDE4_KDESU_LIBS            - the kdesu library and all depending libraries
#  KDE4_KPTY_LIBS             - the kpty library and all depending libraries
#  KDE4_PHONON_LIBS           - the phonon library and all depending librairies
#  KDE4_THREADWEAVER_LIBRARIES- the threadweaver library and all depending libraries
#  KDE4_SOLID_LIBS            - the solid library and all depending libraries
#  KDE4_KNOTIFYCONFIG_LIBS    - the knotify config library and all depending libraries
#  KDE4_KROSSCORE_LIBS        - the kross core library and all depending libraries
#  KDE4_KROSSUI_LIBS          - the kross ui library which includes core and all depending libraries
#  KDE4_KTEXTEDITOR_LIBS      - the ktexteditor library and all depending libraries
#  KDE4_NEPOMUK_LIBS          - the nepomuk library and all depending libraries
#  KDE4_PLASMA_LIBS           - the plasma library and all depending librairies
#  KDE4_KUNITCONVERSION_LIBS  - the kunitconversion library and all depending libraries
#  KDE4_KDEWEBKIT_LIBS        - the kdewebkit library and all depending libraries
#
# This module defines also a bunch of variables used as locations for install directories
# for files of the package which is using this module. These variables don't say
# anything about the location of the installed KDE.
# They can be relative (to CMAKE_INSTALL_PREFIX) or absolute.
# Under Windows they are always relative.
#
#  BIN_INSTALL_DIR          - the directory where executables will be installed (default is prefix/bin)
#  BUNDLE_INSTALL_DIR       - Mac only: the directory where application bundles will be installed (default is /Applications/KDE4 )
#  SBIN_INSTALL_DIR         - the directory where system executables will be installed (default is prefix/sbin)
#  LIB_INSTALL_DIR          - the directory where libraries will be installed (default is prefix/lib)
#  CONFIG_INSTALL_DIR       - the directory where config files will be installed
#  DATA_INSTALL_DIR         - the parent directory where applications can install their data
#  HTML_INSTALL_DIR         - the directory where HTML documentation will be installed
#  ICON_INSTALL_DIR         - the directory where the icons will be installed (default prefix/share/icons/)
#  INFO_INSTALL_DIR         - the directory where info files will be installed (default prefix/info)
#  KCFG_INSTALL_DIR         - the directory where kconfig files will be installed
#  LOCALE_INSTALL_DIR       - the directory where translations will be installed
#  MAN_INSTALL_DIR          - the directory where man pages will be installed (default prefix/man/)
#  MIME_INSTALL_DIR         - the directory where mimetype desktop files will be installed
#  PLUGIN_INSTALL_DIR       - the subdirectory relative to the install prefix where plugins will be installed (default is ${KDE4_LIB_INSTALL_DIR}/kde4)
#  IMPORTS_INSTALL_DIR      - the subdirectory relative to the install prefix where imports will be installed
#  SERVICES_INSTALL_DIR     - the directory where service (desktop, protocol, ...) files will be installed
#  SERVICETYPES_INSTALL_DIR - the directory where servicestypes desktop files will be installed
#  SOUND_INSTALL_DIR        - the directory where sound files will be installed
#  TEMPLATES_INSTALL_DIR    - the directory where templates (Create new file...) will be installed
#  WALLPAPER_INSTALL_DIR    - the directory where wallpapers will be installed
#  AUTOSTART_INSTALL_DIR    - the directory where autostart files will be installed
#  DEMO_INSTALL_DIR         - the directory where demos will be installed
#  KCONF_UPDATE_INSTALL_DIR - the directory where kconf_update files will be installed
#  SYSCONF_INSTALL_DIR      - the directory where sysconfig files will be installed (default /etc)
#  XDG_APPS_INSTALL_DIR     - the XDG apps dir
#  XDG_DIRECTORY_INSTALL_DIR- the XDG directory
#  XDG_MIME_INSTALL_DIR     - the XDG mimetypes install dir
#  DBUS_INTERFACES_INSTALL_DIR - the directory where dbus interfaces will be installed (default is prefix/share/dbus-1/interfaces)
#  DBUS_SERVICES_INSTALL_DIR        - the directory where dbus services will be installed (default is prefix/share/dbus-1/services )
#  DBUS_SYSTEM_SERVICES_INSTALL_DIR        - the directory where dbus system services will be installed (default is prefix/share/dbus-1/system-services )
#
# The variable INSTALL_TARGETS_DEFAULT_ARGS can be used when installing libraries
# or executables into the default locations.
# The INSTALL_TARGETS_DEFAULT_ARGS variable should be used when libraries are installed.
# It should also be used when installing applications, since then
# on OS X application bundles will be installed to BUNDLE_INSTALL_DIR.
# The variable MUST NOT be used for installing plugins.
# It also MUST NOT be used for executables which are intended to go into sbin/ or libexec/.
#
# Usage is like this:
#    install(TARGETS kdecore kdeui ${INSTALL_TARGETS_DEFAULT_ARGS} )
#
# This will install libraries correctly under UNIX, OSX and Windows (i.e. dll's go
# into bin/.
#
#
# The following variable is provided, but seem to be unused:
#  LIBS_HTML_INSTALL_DIR    /share/doc/HTML            CACHE STRING "Is this still used ?")
#
# The following user adjustable options are provided:
#
#  KDE4_ENABLE_FINAL - enable KDE-style enable-final all-in-one-compilation
#  KDE4_BUILD_TESTS  - enable this to build the testcases
#  KDE4_ENABLE_FPIE  - enable it to use gcc Position Independent Executables feature
#  KDE4_USE_COMMON_CMAKE_PACKAGE_CONFIG_DIR - only present for CMake >= 2.6.3, defaults to TRUE
#                      If enabled, the package should install its <package>Config.cmake file to
#                      lib/cmake/<package>/ instead to lib/<package>/cmake
#  KDE4_SERIALIZE_TOOL - wrapper to serialize potentially resource-intensive commands during
#                      parallel builds (set to 'icecc' when using icecream)
#
# It also adds the following macros and functions (from KDE4Macros.cmake)
#  KDE4_ADD_UI_FILES (SRCS_VAR file1.ui ... fileN.ui)
#    Use this to add Qt designer ui files to your application/library.
#
#  KDE4_ADD_UI3_FILES (SRCS_VAR file1.ui ... fileN.ui)
#    Use this to add Qt designer ui files from Qt version 3 to your application/library.
#
#  KDE4_ADD_KCFG_FILES (SRCS_VAR [GENERATE_MOC] [USE_RELATIVE_PATH] file1.kcfgc ... fileN.kcfgc)
#    Use this to add KDE config compiler files to your application/library.
#    Use optional GENERATE_MOC to generate moc if you use signals in your kcfg files.
#    Use optional USE_RELATIVE_PATH to generate the classes in the build following the given
#    relative path to the file.
#
#  KDE4_ADD_WIDGET_FILES (SRCS_VAR file1.widgets ... fileN.widgets)
#    Use this to add widget description files for the makekdewidgets code generator
#    for Qt Designer plugins.
#
#  KDE4_CREATE_FINAL_FILES (filename_CXX filename_C file1 ... fileN)
#    This macro is intended mainly for internal uses.
#    It is used for enable-final. It will generate two source files,
#    one for the C files and one for the C++ files.
#    These files will have the names given in filename_CXX and filename_C.
#
#  KDE4_ADD_PLUGIN ( name [WITH_PREFIX] file1 ... fileN )
#    Create a KDE plugin (KPart, kioslave, etc.) from the given source files.
#    It supports KDE4_ENABLE_FINAL.
#    If WITH_PREFIX is given, the resulting plugin will have the prefix "lib", otherwise it won't.
#
#  KDE4_ADD_KDEINIT_EXECUTABLE (name [NOGUI] [RUN_UNINSTALLED] file1 ... fileN)
#    Create a KDE application in the form of a module loadable via kdeinit.
#    A library named kdeinit_<name> will be created and a small executable which links to it.
#    It supports KDE4_ENABLE_FINAL
#    If the executable doesn't have a GUI, use the option NOGUI. By default on OS X
#    application bundles are created, with the NOGUI option no bundles but simple executables
#    are created. Under Windows this flag is also necessary to separate between applications
#    with GUI and without. On other UNIX systems this flag has no effect.
#    RUN_UNINSTALLED is deprecated and is ignored, for details see the documentation for
#    KDE4_ADD_EXECUTABLE().
#
#  KDE4_ADD_EXECUTABLE (name [NOGUI] [TEST] [RUN_UNINSTALLED] file1 ... fileN)
#    Equivalent to ADD_EXECUTABLE(), but additionally adds some more features:
#    -support for KDE4_ENABLE_FINAL
#    -support for automoc
#    -automatic RPATH handling
#    If the executable doesn't have a GUI, use the option NOGUI. By default on OS X
#    application bundles are created, with the NOGUI option no bundles but simple executables
#    are created. Under Windows this flag is also necessary to separate between applications
#    with GUI and without. On other UNIX systems this flag has no effect.
#    The option TEST is for internal use only.
#    The option RUN_UNINSTALLED is ignored. It was necessary with KDE 4.0 and 4.1
#    if the executable had to be run from the build tree. Since KDE 4.2 all
#    executables can be always run uninstalled (the RPATH of executables which are not
#    yet installed points since then into the buildtree and is changed
#    to the proper location when installing, so RUN_UNINSTALLED is not necessary anymore).
#
#  KDE4_ADD_LIBRARY (name [STATIC | SHARED | MODULE ] file1 ... fileN)
#    Equivalent to ADD_LIBRARY(). Additionally it supports KDE4_ENABLE_FINAL,
#    includes automoc-handling and sets LINK_INTERFACE_LIBRARIES target property empty.
#    The RPATH is set according to the global RPATH settings as set up by FindKDE4Internal.cmake
#    (CMAKE_SKIP_BUILD_RPATH=FALSE, CMAKE_BUILD_WITH_INSTALL_RPATH=FALSE, CMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE)
#    Under Windows it adds a -DMAKE_<name>_LIB definition to the compilation.
#
#  KDE4_ADD_UNIT_TEST (testname [TESTNAME targetname] file1 ... fileN)
#    add a unit test, which is executed when running make test
#    it will be built with RPATH poiting to the build dir
#    The targets are always created, but only built for the "all"
#    target if the option KDE4_BUILD_TESTS is enabled. Otherwise the rules for the target
#    are created but not built by default. You can build them by manually building the target.
#    The name of the target can be specified using TESTNAME <targetname>, if it is not given
#    the macro will default to the <testname>
#    KDESRCDIR is set to the source directory of the test, this can be used with
#    KGlobal::dirs()->addResourceDir( "data", KDESRCDIR )
#
#
#  KDE4_ADD_APP_ICON (SRCS_VAR pattern)
#  adds an application icon to target source list.
#  Make sure you have a 128x128 icon, or the icon won't display on Mac OS X.
#  Mac OSX notes : the application icon is added to a Mac OS X bundle so that Finder and friends show the right thing.
#  Win32 notes: the application icon(s) are compiled into the application
#  There is some workaround in kde4_add_kdeinit_executable to make it possible for those applications as well.
# Parameters:
#  SRCS_VAR  - specifies the list of source files
#  pattern   - regular expression for searching application icons
#  Example: KDE4_ADD_APP_ICON( myapp_SOURCES "pics/cr*-myapp.png")
#  Example: KDE4_ADD_APP_ICON( myapp_KDEINIT_SRCS "icons/oxygen/*/apps/myapp.png")
#
#  KDE4_UPDATE_ICONCACHE()
#    Notifies the icon cache that new icons have been installed by updating
#    mtime of ${ICON_INSTALL_DIR}/hicolor directory.
#
#  KDE4_INSTALL_ICONS( path theme)
#    Installs all png and svgz files in the current directory to the icon
#    directory given in path, in the subdirectory for the given icon theme.
#
#  KDE4_CREATE_HANDBOOK( docbookfile [INSTALL_DESTINATION installdest] [SUBDIR subdir])
#   Create the handbook from the docbookfile (using meinproc4)
#   The resulting handbook will be installed to <installdest> when using
#   INSTALL_DESTINATION <installdest>, or to <installdest>/<subdir> if
#   SUBDIR <subdir> is specified.
#
#  KDE4_CREATE_MANPAGE( docbookfile section )
#   Create the manpage for the specified section from the docbookfile (using meinproc4)
#   The resulting manpage will be installed to <installdest> when using
#   INSTALL_DESTINATION <installdest>, or to <installdest>/<subdir> if
#   SUBDIR <subdir> is specified.
#
#  KDE4_INSTALL_AUTH_ACTIONS( HELPER_ID ACTIONS_FILE )
#   This macro generates an action file, depending on the backend used, for applications using KAuth.
#   It accepts the helper id (the DBUS name) and a file containing the actions (check kdelibs/kdecore/auth/example
#   for file format). The macro will take care of generating the file according to the backend specified,
#   and to install it in the right location. This (at the moment) means that on Linux (PolicyKit) a .policy
#   file will be generated and installed into the policykit action directory (usually /usr/share/PolicyKit/policy/),
#   and on Mac (Authorization Services) will be added to the system action registry using the native MacOS API during
#   the install phase
#
#  KDE4_INSTALL_AUTH_HELPER_FILES( HELPER_TARGET HELPER_ID HELPER_USER )
#   This macro adds the needed files for an helper executable meant to be used by applications using KAuth.
#   It accepts the helper target, the helper ID (the DBUS name) and the user under which the helper will run on.
#   This macro takes care of generate the needed files, and install them in the right location. This boils down
#   to a DBus policy to let the helper register on the system bus, and a service file for letting the helper
#   being automatically activated by the system bus.
#   *WARNING* You have to install the helper in ${LIBEXEC_INSTALL_DIR} to make sure everything will work.
#
#
#
#  A note on the possible values for CMAKE_BUILD_TYPE and how KDE handles
#  the flags for those buildtypes. FindKDE4Internal supports the values
#  Debug, Release, RelWithDebInfo, Profile and Debugfull:
#
#  Release
#          optimised for speed, qDebug/kDebug turned off, no debug symbols, no asserts
#  RelWithDebInfo (Release with debug info)
#          similar to Release, optimised for speed, but with debugging symbols on (-g)
#  Debug
#          optimised but debuggable, debugging on (-g)
#          (-fno-reorder-blocks -fno-schedule-insns -fno-inline)
#  DebugFull
#          no optimization, full debugging on (-g3)
#  Profile
#          DebugFull + -ftest-coverage -fprofile-arcs
#
#
#  The default buildtype is RelWithDebInfo.
#  It is expected that the "Debug" build type be still debuggable with gdb
#  without going all over the place, but still produce better performance.
#  It's also important to note that gcc cannot detect all warning conditions
#  unless the optimiser is active.
#
#
#  This module allows to depend on a particular minimum version of kdelibs.
#  To acomplish that one should use the appropriate cmake syntax for
#  find_package. For example to depend on kdelibs >= 4.1.0 one should use
#
#  find_package(KDE4 4.1.0 REQUIRED)
#
#  In earlier versions of KDE you could use the variable KDE_MIN_VERSION to
#  have such a dependency. This variable is deprecated with KDE 4.2.0, but
#  will still work to make the module backwards-compatible.

#  _KDE4_PLATFORM_INCLUDE_DIRS is used only internally
#  _KDE4_PLATFORM_DEFINITIONS is used only internally

# Copyright (c) 2006-2009, Alexander Neundorf <neundorf@kde.org>
# Copyright (c) 2006, Laurent Montel, <montel@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


message(STATUS "Using private FindKDE4Internal module to deactivate hidden visibility building")

# this is required now by cmake 2.6 and so must not be skipped by if(KDE4_FOUND) below
cmake_minimum_required(VERSION 2.8.9 FATAL_ERROR)
# set the cmake policies to the 2.4.x compatibility settings (may change for KDE 4.3)
cmake_policy(VERSION 2.4.5)

# Policy 25=new: identify Apple Clang as AppleClang to ensure
#                consistency in compiler feature determination
# Policy 60=new: don't rewrite ${prefix}/lib/libfoo.dylib as -lfoo
cmake_policy(SET CMP0025 NEW)
cmake_policy(SET CMP0060 NEW)

# Only do something if it hasn't been found yet
if(NOT KDE4_FOUND)

# get the directory of the current file, used later on in the file
#get_filename_component( kde_cmake_module_dir  ${CMAKE_CURRENT_LIST_FILE} PATH)
set( kde_cmake_module_dir  "@PREFIX@/share/apps/cmake/modules")


include (MacroEnsureVersion)

# We may only search for other packages with "REQUIRED" if we are required ourselves.
# This file can be processed either (usually) included in FindKDE4.cmake or
# (when building kdelibs) directly via FIND_PACKAGE(KDE4Internal), that's why
# we have to check for both KDE4_FIND_REQUIRED and KDE4Internal_FIND_REQUIRED.
if(KDE4_FIND_REQUIRED  OR  KDE4Internal_FIND_REQUIRED)
  set(_REQ_STRING_KDE4 "REQUIRED")
  set(_REQ_STRING_KDE4_MESSAGE "FATAL_ERROR")
else(KDE4_FIND_REQUIRED  OR  KDE4Internal_FIND_REQUIRED)
  set(_REQ_STRING_KDE4 )
  set(_REQ_STRING_KDE4_MESSAGE "STATUS")
endif(KDE4_FIND_REQUIRED  OR  KDE4Internal_FIND_REQUIRED)


# Store CMAKE_MODULE_PATH and then append the current dir to it, so we are sure
# we get the FindQt4.cmake located next to us and not a different one.
# The original CMAKE_MODULE_PATH is restored later on.
set(_kde_cmake_module_path_back ${CMAKE_MODULE_PATH})
set(CMAKE_MODULE_PATH ${kde_cmake_module_dir} ${CMAKE_MODULE_PATH} )

# if the minimum Qt requirement is changed, change all occurrence in the
# following lines
if( NOT QT_MIN_VERSION )
  set(QT_MIN_VERSION "4.8.0")
endif( NOT QT_MIN_VERSION )
if( ${QT_MIN_VERSION} VERSION_LESS "4.8.0" )
  set(QT_MIN_VERSION "4.8.0")
endif( ${QT_MIN_VERSION} VERSION_LESS "4.8.0" )

# Tell FindQt4.cmake to point the QT_QTFOO_LIBRARY targets at the imported targets
# for the Qt libraries, so we get full handling of release and debug versions of the
# Qt libs and are flexible regarding the install location of Qt under Windows:
set(QT_USE_IMPORTED_TARGETS TRUE)

#this line includes FindQt4.cmake, which searches the Qt library and headers
# TODO: we should check here that all necessary modules of Qt have been found, e.g. QtDBus
find_package(Qt4 ${_REQ_STRING_KDE4})

# automoc4 (from kdesupport) is now required, Alex
find_package(Automoc4 ${_REQ_STRING_KDE4})

# cmake 2.6.0 and automoc4 < 0.9.84 don't work right for -D flags
if (NOT AUTOMOC4_VERSION)
   # the version macro was added for 0.9.84
   set(AUTOMOC4_VERSION "0.9.83")
endif (NOT AUTOMOC4_VERSION)
set(_automoc4_min_version "0.9.88")
macro_ensure_version("${_automoc4_min_version}" "${AUTOMOC4_VERSION}" _automoc4_version_ok)

# for compatibility with KDE 4.0.x
set(KDE4_AUTOMOC_EXECUTABLE        "${AUTOMOC4_EXECUTABLE}" )

# Perl is not required for building KDE software, but we had that here since 4.0
find_package(Perl)
if(NOT PERL_FOUND)
   message(STATUS "Perl not found")
endif(NOT PERL_FOUND)

# restore the original CMAKE_MODULE_PATH
set(CMAKE_MODULE_PATH ${_kde_cmake_module_path_back})

# we check for Phonon not here, but further below, i.e. after KDELibsDependencies.cmake
# has been loaded, which helps in the case that phonon is installed to the same
# directory as kdelibs.
# find_package(Phonon ${_REQ_STRING_KDE4})


# Check that we really found everything.
# If KDE4 was searched with REQUIRED, we error out with FATAL_ERROR if something wasn't found
# already above in the other FIND_PACKAGE() calls.
# If KDE4 was searched without REQUIRED and something in the FIND_PACKAGE() calls above wasn't found,
# then we get here and must check that everything has actually been found. If something is missing,
# we must not fail with FATAL_ERROR, but only not set KDE4_FOUND.

if(NOT QT4_FOUND)
   message(STATUS "KDE4 not found, because Qt4 was not found")
   return()
endif(NOT QT4_FOUND)

if(NOT AUTOMOC4_FOUND OR NOT _automoc4_version_ok)
   if(NOT AUTOMOC4_FOUND)
      message(${_REQ_STRING_KDE4_MESSAGE} "KDE4 not found, because Automoc4 not found.")
      return()
   else(NOT AUTOMOC4_FOUND)
      if(NOT _automoc4_version_ok)
         message(${_REQ_STRING_KDE4_MESSAGE} "Your version of automoc4 is too old. You have ${AUTOMOC4_VERSION}, you need at least ${_automoc4_min_version}")
         return()
      endif(NOT _automoc4_version_ok)
   endif(NOT AUTOMOC4_FOUND)
endif(NOT AUTOMOC4_FOUND OR NOT _automoc4_version_ok)


# now we are sure we have everything we need

include (MacroLibrary)
include (CheckCXXCompilerFlag)
include (CheckCXXSourceCompiles)


# are we trying to compile kdelibs ? kdelibs_SOURCE_DIR comes from "project(kdelibs)" in kdelibs/CMakeLists.txt
# then enter bootstrap mode

if(kdelibs_SOURCE_DIR)
   set(_kdeBootStrapping TRUE)
   message(STATUS "Building kdelibs...")
else(kdelibs_SOURCE_DIR)
   set(_kdeBootStrapping FALSE)
endif(kdelibs_SOURCE_DIR)


# helper macro, sets both the KDE4_FOO_LIBRARY and KDE4_FOO_LIBS variables to KDE4__foo
# It is used both in bootstrapping and in normal mode.
macro(_KDE4_SET_LIB_VARIABLES _var _lib _prefix)
   set(KDE4_${_var}_LIBRARY ${_prefix}${_lib} )
   set(KDE4_${_var}_LIBS    ${_prefix}${_lib} )
endmacro(_KDE4_SET_LIB_VARIABLES _var _lib _prefix)

#######################  #now try to find some kde stuff  ################################

if (_kdeBootStrapping)
   set(KDE4_INCLUDE_DIR ${kdelibs_SOURCE_DIR})

   set(EXECUTABLE_OUTPUT_PATH ${kdelibs_BINARY_DIR}/bin )

   if (WIN32)
      set(LIBRARY_OUTPUT_PATH               ${EXECUTABLE_OUTPUT_PATH} )
      # CMAKE_CFG_INTDIR is the output subdirectory created e.g. by XCode and MSVC
      if (NOT WINCE)
        set(KDE4_KCFGC_EXECUTABLE             ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/kconfig_compiler )
        set(KDE4_MEINPROC_EXECUTABLE          ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/meinproc4 )
      else (NOT WINCE)
        set(KDE4_KCFGC_EXECUTABLE             ${HOST_BINDIR}/${CMAKE_CFG_INTDIR}/kconfig_compiler )
        set(KDE4_MEINPROC_EXECUTABLE          ${HOST_BINDIR}/${CMAKE_CFG_INTDIR}/meinproc4 )
      endif(NOT WINCE)

      set(KDE4_MEINPROC_EXECUTABLE          ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/meinproc4 )
      set(KDE4_KAUTH_POLICY_GEN_EXECUTABLE  ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/kauth-policy-gen )
      set(KDE4_MAKEKDEWIDGETS_EXECUTABLE    ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/makekdewidgets )
   else (WIN32)
      set(LIBRARY_OUTPUT_PATH               ${CMAKE_BINARY_DIR}/lib )
      set(KDE4_KCFGC_EXECUTABLE             ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/kconfig_compiler${CMAKE_EXECUTABLE_SUFFIX}.shell )
      set(KDE4_KAUTH_POLICY_GEN_EXECUTABLE  ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/kauth-policy-gen${CMAKE_EXECUTABLE_SUFFIX}.shell )
      set(KDE4_MEINPROC_EXECUTABLE          ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/meinproc4${CMAKE_EXECUTABLE_SUFFIX}.shell )
      set(KDE4_MAKEKDEWIDGETS_EXECUTABLE    ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/makekdewidgets${CMAKE_EXECUTABLE_SUFFIX}.shell )
   endif (WIN32)

   set(KDE4_LIB_DIR ${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR})


   # when building kdelibs, make the kcfg rules depend on the binaries...
   set( _KDE4_KCONFIG_COMPILER_DEP kconfig_compiler)
   set( _KDE4_KAUTH_POLICY_GEN_EXECUTABLE_DEP kauth-policy-gen)
   set( _KDE4_MAKEKDEWIDGETS_DEP makekdewidgets)
   set( _KDE4_MEINPROC_EXECUTABLE_DEP meinproc4)

   set(KDE4_INSTALLED_VERSION_OK TRUE)

else (_kdeBootStrapping)

  # ... but NOT otherwise
   set( _KDE4_KCONFIG_COMPILER_DEP)
   set( _KDE4_MAKEKDEWIDGETS_DEP)
   set( _KDE4_MEINPROC_EXECUTABLE_DEP)
   set( _KDE4_KAUTH_POLICY_GEN_EXECUTABLE_DEP)

   set(LIBRARY_OUTPUT_PATH  ${CMAKE_BINARY_DIR}/lib )

   if (WIN32)
      # we don't want to be forced to set two paths into the build tree
      set(LIBRARY_OUTPUT_PATH  ${CMAKE_BINARY_DIR}/bin )

      # on win32 the install dir is determined on runtime not install time
      # KDELIBS_INSTALL_DIR and QT_INSTALL_DIR are used in KDELibsDependencies.cmake to setup
      # kde install paths and library dependencies
      get_filename_component(_DIR ${KDE4_KDECONFIG_EXECUTABLE} PATH )
      get_filename_component(KDE4_INSTALL_DIR ${_DIR} PATH )
      get_filename_component(_DIR ${QT_QMAKE_EXECUTABLE} PATH )
      get_filename_component(QT_INSTALL_DIR ${_DIR} PATH )
   endif (WIN32)

   # These files contain information about the installed kdelibs, Alex
   include(${kde_cmake_module_dir}/KDELibsDependencies.cmake)
   include(${kde_cmake_module_dir}/KDEPlatformProfile.cmake)

   # Check the version of KDE. It must be at least KDE_MIN_VERSION as set by the user.
   # KDE_VERSION is set in KDELibsDependencies.cmake since KDE 4.0.x. Alex
   # Support for the new-style (>= 2.6.0) support for requiring some version of a package:
   if (NOT KDE_MIN_VERSION)
      if (KDE4_FIND_VERSION_MAJOR)
         set(KDE_MIN_VERSION "${KDE4_FIND_VERSION_MAJOR}.${KDE4_FIND_VERSION_MINOR}.${KDE4_FIND_VERSION_PATCH}")
      else (KDE4_FIND_VERSION_MAJOR)
         set(KDE_MIN_VERSION "4.0.0")
      endif (KDE4_FIND_VERSION_MAJOR)
   endif (NOT KDE_MIN_VERSION)

   #message(FATAL_ERROR "KDE_MIN_VERSION=${KDE_MIN_VERSION}  found ${KDE_VERSION} exact: -${KDE4_FIND_VERSION_EXACT}- version: -${KDE4_FIND_VERSION}-")
   macro_ensure_version( ${KDE_MIN_VERSION} ${KDE_VERSION} KDE4_INSTALLED_VERSION_OK )


   # KDE4_LIB_INSTALL_DIR and KDE4_INCLUDE_INSTALL_DIR are set in KDELibsDependencies.cmake,
   # use them to set the KDE4_LIB_DIR and KDE4_INCLUDE_DIR "public interface" variables
   set(KDE4_LIB_DIR ${KDE4_LIB_INSTALL_DIR} )
   set(KDE4_INCLUDE_DIR ${KDE4_INCLUDE_INSTALL_DIR} )


   # This setting is currently not recorded in KDELibsDependencies.cmake:
   find_file(KDE4_PLASMA_OPENGL_FOUND plasma/glapplet.h PATHS ${KDE4_INCLUDE_DIR} NO_DEFAULT_PATH)

   # Now include the file with the imported tools (executable targets).
   # This export-file is generated and installed by the toplevel CMakeLists.txt of kdelibs.
   # Having the libs and tools in two separate files should help with cross compiling.
   include(${kde_cmake_module_dir}/KDELibs4ToolsTargets.cmake)

   # get the build CONFIGURATIONS which were exported in this file, and use just the first
   # of them to get the location of the installed executables
   get_target_property(_importedConfigurations  ${KDE4_TARGET_PREFIX}kconfig_compiler IMPORTED_CONFIGURATIONS )
   list(GET _importedConfigurations 0 _firstConfig)

   if(NOT WINCE)
   get_target_property(KDE4_KCFGC_EXECUTABLE             ${KDE4_TARGET_PREFIX}kconfig_compiler    LOCATION_${_firstConfig})
   get_target_property(KDE4_MEINPROC_EXECUTABLE          ${KDE4_TARGET_PREFIX}meinproc4           LOCATION_${_firstConfig})
   else(NOT WINCE)
    set(KDE4_KCFGC_EXECUTABLE             ${HOST_BINDIR}/${CMAKE_CFG_INTDIR}/kconfig_compiler )
    set(KDE4_MEINPROC_EXECUTABLE          ${HOST_BINDIR}/${CMAKE_CFG_INTDIR}/meinproc4 )
   endif(NOT WINCE)
   get_target_property(KDE4_KAUTH_POLICY_GEN_EXECUTABLE  ${KDE4_TARGET_PREFIX}kauth-policy-gen    LOCATION_${_firstConfig})
   get_target_property(KDE4_MAKEKDEWIDGETS_EXECUTABLE    ${KDE4_TARGET_PREFIX}makekdewidgets      LOCATION_${_firstConfig})

   # allow searching cmake modules in all given kde install locations (KDEDIRS based)
   execute_process(COMMAND "${KDE4_KDECONFIG_EXECUTABLE}" --path data OUTPUT_VARIABLE _data_DIR ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
   file(TO_CMAKE_PATH "${_data_DIR}" _data_DIR)
   foreach(dir ${_data_DIR})
      set (apath "${dir}/cmake/modules")
      if (EXISTS "${apath}")
         set (included 0)
         string(TOLOWER "${apath}" _apath)
         # ignore already added pathes, case insensitive
         foreach(adir ${CMAKE_MODULE_PATH})
            string(TOLOWER "${adir}" _adir)
            if ("${_adir}" STREQUAL "${_apath}")
               set (included 1)
            endif ("${_adir}" STREQUAL "${_apath}")
         endforeach(adir)
         if (NOT included)
            message(STATUS "Adding ${apath} to CMAKE_MODULE_PATH")
            set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${apath}")
         endif (NOT included)
      endif (EXISTS "${apath}")
   endforeach(dir)


   # This file contains the exported library target from kdelibs (new with cmake 2.6.x), e.g.
   # the library target "kdeui" is exported as "KDE4__kdeui". The "KDE4__" is used as
   # "namespace" to separate the imported targets from "normal" targets, it is stored in
   # KDE4_TARGET_PREFIX, which is set in KDELibsDependencies.cmake .
   # This export-file is generated and installed by the toplevel CMakeLists.txt of kdelibs.
   # Include it to "import" the libraries from kdelibs into the current projects as targets.
   # This makes setting the _LIBRARY and _LIBS variables actually a bit superfluos, since e.g.
   # the kdeui library could now also be used just as "KDE4__kdeui" and still have all their
   # dependent libraries handled correctly. But to keep compatibility and not to change
   # behaviour we set all these variables anyway as seen below. Alex
   include(${kde_cmake_module_dir}/KDELibs4LibraryTargets.cmake)

   # This one is for compatibility only:
   set(KDE4_THREADWEAVER_LIBRARIES ${KDE4_TARGET_PREFIX}threadweaver )

endif (_kdeBootStrapping)


# Set the various KDE4_FOO_LIBRARY/LIBS variables.
# In bootstrapping mode KDE4_TARGET_PREFIX is empty, so e.g. KDE4_KDECORE_LIBRARY
# will be simply set to "kdecore".

# Sorted by names:
_kde4_set_lib_variables(KCMUTILS      kcmutils      "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KDE3SUPPORT   kde3support   "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KDECORE       kdecore       "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KDEUI         kdeui         "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KDEWEBKIT     kdewebkit     "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KDNSSD        kdnssd        "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KEMOTICONS    kemoticons    "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KFILE         kfile         "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KHTML         khtml         "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KIDLETIME     kidletime     "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KIO           kio           "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KJS           kjs           "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KJSAPI        kjsapi        "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KNEWSTUFF2    knewstuff2    "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KNEWSTUFF3    knewstuff3    "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KNOTIFYCONFIG knotifyconfig "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KPARTS        kparts        "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KPRINTUTILS   kprintutils   "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KROSSCORE     krosscore     "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KROSSUI       krossui       "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KTEXTEDITOR   ktexteditor   "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KUNITCONVERSION kunitconversion "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(KUTILS        kutils        "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(PLASMA        plasma        "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(SOLID         solid         "${KDE4_TARGET_PREFIX}")
_kde4_set_lib_variables(THREADWEAVER  threadweaver  "${KDE4_TARGET_PREFIX}")

if (UNIX)
   _kde4_set_lib_variables(KDEFAKES kdefakes "${KDE4_TARGET_PREFIX}")
   _kde4_set_lib_variables(KDESU kdesu       "${KDE4_TARGET_PREFIX}")
   _kde4_set_lib_variables(KPTY kpty         "${KDE4_TARGET_PREFIX}")
endif (UNIX)

# The nepomuk target does not always exist, since is is built conditionally. When bootstrapping
# we set it always anyways.
if(_kdeBootStrapping  OR  TARGET ${KDE4_TARGET_PREFIX}nepomuk)
   _kde4_set_lib_variables(NEPOMUK nepomuk "${KDE4_TARGET_PREFIX}")
endif(_kdeBootStrapping  OR  TARGET ${KDE4_TARGET_PREFIX}nepomuk)


################### try to find Phonon ############################################

# we do this here instead of above together with the checks for Perl etc.
# since FindPhonon.cmake also uses ${KDE4_LIB_INSTALL_DIR} to check for Phonon,
# which helps with finding the phonon installed as part of kdesupport:

# only make Phonon REQUIRED if KDE4 itself is REQUIRED
find_package(Phonon 4.3.80 ${_REQ_STRING_KDE4})
set(KDE4_PHONON_LIBRARY ${PHONON_LIBRARY})
set(KDE4_PHONON_LIBS ${PHONON_LIBS})
set(KDE4_PHONON_INCLUDES ${PHONON_INCLUDES})

if(NOT PHONON_FOUND)
   message(STATUS "KDE4 not found, because Phonon was not found")
   return()
endif(NOT PHONON_FOUND)


#####################  provide some options   ##########################################

option(KDE4_ENABLE_FINAL "Enable final all-in-one compilation")
option(KDE4_BUILD_TESTS  "Build the tests" ON)
option(KDE4_ENABLE_HTMLHANDBOOK  "Create targets htmlhandbook for creating the html versions of the docbook docs")
set(KDE4_SERIALIZE_TOOL "" CACHE STRING "Tool to serialize resource-intensive commands in parallel builds")

# if CMake 2.6.3 or above is used, provide an option which should be used by other KDE packages
# whether to install a CMake FooConfig.cmake into lib/foo/cmake/ or /lib/cmake/foo/
# (with 2.6.3 and above also lib/cmake/foo/ is supported):
if(${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION} VERSION_GREATER 2.6.2)
   option(KDE4_USE_COMMON_CMAKE_PACKAGE_CONFIG_DIR "Prefer to install the <package>Config.cmake files to lib/cmake/<package> instead to lib/<package>/cmake" TRUE)
else(${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION} VERSION_GREATER 2.6.2)
   set(KDE4_USE_COMMON_CMAKE_PACKAGE_CONFIG_DIR  FALSE)
endif(${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION} VERSION_GREATER 2.6.2)

# Position-Independent-Executable is a feature of Binutils, Libc, and GCC that creates an executable
# which is something between a shared library and a normal executable.
# Programs compiled with these features appear as ?shared object? with the file command.
# info from "http://www.linuxfromscratch.org/hlfs/view/unstable/glibc/chapter02/pie.html"
option(KDE4_ENABLE_FPIE  "Enable platform supports PIE linking")

if (WIN32)
   list(APPEND CMAKE_MODULE_PATH "${CMAKE_INSTALL_PREFIX}/share/apps/cmake/modules")
   find_package(KDEWin REQUIRED)
   option(KDE4_ENABLE_UAC_MANIFEST "add manifest to make vista uac happy" OFF)
   if (KDE4_ENABLE_UAC_MANIFEST)
      find_program(KDE4_MT_EXECUTABLE mt
         PATHS ${KDEWIN_INCLUDE_DIR}/../bin
         NO_DEFAULT_PATH
      )
      if (KDE4_MT_EXECUTABLE)
         message(STATUS "Found KDE manifest tool at ${KDE4_MT_EXECUTABLE} ")
      else (KDE4_MT_EXECUTABLE)
         message(STATUS "KDE manifest tool not found, manifest generating for Windows Vista disabled")
         set (KDE4_ENABLE_UAC_MANIFEST OFF)
      endif (KDE4_MT_EXECUTABLE)
   endif (KDE4_ENABLE_UAC_MANIFEST)
endif (WIN32)

#####################  some more settings   ##########################################

if( KDE4_ENABLE_FINAL)
   add_definitions(-DKDE_USE_FINAL)
endif(KDE4_ENABLE_FINAL)

if(KDE4_SERIALIZE_TOOL)
   # parallel build with many meinproc invocations can consume a huge amount of memory
   set(KDE4_MEINPROC_EXECUTABLE ${KDE4_SERIALIZE_TOOL} ${KDE4_MEINPROC_EXECUTABLE})
endif(KDE4_SERIALIZE_TOOL)

# If we are building ! kdelibs, check where kdelibs are installed.
# If they are installed in a directory which contains "lib64", we default to "64" for LIB_SUFFIX,
# so the current project will by default also go into lib64.
# The same for lib32. Alex
set(_Init_LIB_SUFFIX "")
if ("${KDE4_LIB_DIR}" MATCHES lib64)
   set(_Init_LIB_SUFFIX 64)
endif ("${KDE4_LIB_DIR}" MATCHES lib64)
if ("${KDE4_LIB_DIR}" MATCHES lib32)
   set(_Init_LIB_SUFFIX 32)
endif ("${KDE4_LIB_DIR}" MATCHES lib32)

set(LIB_SUFFIX "${_Init_LIB_SUFFIX}" CACHE STRING "Define suffix of directory name (32/64)" )


########## the following are directories where stuff will be installed to  ###########
#
# this has to be after find_xxx() block above, since there KDELibsDependencies.cmake is included
# which contains the install dirs from kdelibs, which are reused below

if (WIN32)
# use relative install prefix to avoid hardcoded install paths in cmake_install.cmake files

   set(LIB_INSTALL_DIR      "lib${LIB_SUFFIX}" )            # The subdirectory relative to the install prefix where libraries will be installed (default is ${EXEC_INSTALL_PREFIX}/lib${LIB_SUFFIX})

   set(EXEC_INSTALL_PREFIX  "" )        # Base directory for executables and libraries
   set(SHARE_INSTALL_PREFIX "share" )   # Base directory for files which go to share/
   set(BIN_INSTALL_DIR      "bin"   )   # The install dir for executables (default ${EXEC_INSTALL_PREFIX}/bin)
   set(SBIN_INSTALL_DIR     "sbin"  )   # The install dir for system executables (default ${EXEC_INSTALL_PREFIX}/sbin)

   set(LIBEXEC_INSTALL_DIR  "${BIN_INSTALL_DIR}"          ) # The subdirectory relative to the install prefix where libraries will be installed (default is ${BIN_INSTALL_DIR})
   set(INCLUDE_INSTALL_DIR  "include"                     ) # The subdirectory to the header prefix

   set(PLUGIN_INSTALL_DIR       "lib${LIB_SUFFIX}/kde4"   ) #                "The subdirectory relative to the install prefix where plugins will be installed (default is ${LIB_INSTALL_DIR}/kde4)
   set(IMPORTS_INSTALL_DIR       "${PLUGIN_INSTALL_DIR}/imports"   ) # "The subdirectory relative to the install prefix where imports will be installed
   set(CONFIG_INSTALL_DIR       "share/config"            ) # The config file install dir
   set(DATA_INSTALL_DIR         "share/apps"              ) # The parent directory where applications can install their data
   set(HTML_INSTALL_DIR         "share/doc/HTML"          ) # The HTML install dir for documentation
   set(ICON_INSTALL_DIR         "share/icons"             ) # The icon install dir (default ${SHARE_INSTALL_PREFIX}/share/icons/)
   set(KCFG_INSTALL_DIR         "share/config.kcfg"       ) # The install dir for kconfig files
   set(LOCALE_INSTALL_DIR       "share/locale"            ) # The install dir for translations
   set(MIME_INSTALL_DIR         "share/mimelnk"           ) # The install dir for the mimetype desktop files
   set(SERVICES_INSTALL_DIR     "share/kde4/services"     ) # The install dir for service (desktop, protocol, ...) files
   set(SERVICETYPES_INSTALL_DIR "share/kde4/servicetypes" ) # The install dir for servicestypes desktop files
   set(SOUND_INSTALL_DIR        "share/sounds"            ) # The install dir for sound files
   set(TEMPLATES_INSTALL_DIR    "share/templates"         ) # The install dir for templates (Create new file...)
   set(WALLPAPER_INSTALL_DIR    "share/wallpapers"        ) # The install dir for wallpapers
   set(DEMO_INSTALL_DIR         "share/demos"             ) # The install dir for demos
   set(KCONF_UPDATE_INSTALL_DIR "share/apps/kconf_update" ) # The kconf_update install dir
   set(AUTOSTART_INSTALL_DIR    "share/autostart"         ) # The install dir for autostart files

   set(XDG_APPS_INSTALL_DIR      "share/applications/kde4"   ) # The XDG apps dir
   set(XDG_DIRECTORY_INSTALL_DIR "share/desktop-directories" ) # The XDG directory
   set(XDG_MIME_INSTALL_DIR      "share/mime/packages"       ) # The install dir for the xdg mimetypes

   set(SYSCONF_INSTALL_DIR       "etc"                       ) # The sysconfig install dir (default /etc)
   set(MAN_INSTALL_DIR           "share/man"                 ) # The man install dir (default ${SHARE_INSTALL_PREFIX}/man/)
   set(INFO_INSTALL_DIR          "share/info"                ) # The info install dir (default ${SHARE_INSTALL_PREFIX}/info)")
   set(DBUS_INTERFACES_INSTALL_DIR "share/dbus-1/interfaces" ) # The dbus interfaces install dir (default  ${SHARE_INSTALL_PREFIX}/dbus-1/interfaces)")
   set(DBUS_SERVICES_INSTALL_DIR "share/dbus-1/services"     ) # The dbus services install dir (default  ${SHARE_INSTALL_PREFIX}/dbus-1/services)")
   set(DBUS_SYSTEM_SERVICES_INSTALL_DIR "share/dbus-1/system-services"     ) # The dbus system services install dir (default  ${SHARE_INSTALL_PREFIX}/dbus-1/system-services)")

else (WIN32)

   # This macro implements some very special logic how to deal with the cache.
   # By default the various install locations inherit their value from their "parent" variable
   # so if you set CMAKE_INSTALL_PREFIX, then EXEC_INSTALL_PREFIX, PLUGIN_INSTALL_DIR will
   # calculate their value by appending subdirs to CMAKE_INSTALL_PREFIX .
   # This would work completely without using the cache.
   # But if somebody wants e.g. a different EXEC_INSTALL_PREFIX this value has to go into
   # the cache, otherwise it will be forgotten on the next cmake run.
   # Once a variable is in the cache, it doesn't depend on its "parent" variables
   # anymore and you can only change it by editing it directly.
   # this macro helps in this regard, because as long as you don't set one of the
   # variables explicitly to some location, it will always calculate its value from its
   # parents. So modifying CMAKE_INSTALL_PREFIX later on will have the desired effect.
   # But once you decide to set e.g. EXEC_INSTALL_PREFIX to some special location
   # this will go into the cache and it will no longer depend on CMAKE_INSTALL_PREFIX.
   #
   # additionally if installing to the same location as kdelibs, the other install
   # directories are reused from the installed kdelibs
   macro(_SET_FANCY _var _value _comment)
      set(predefinedvalue "${_value}")
      if ("${CMAKE_INSTALL_PREFIX}" STREQUAL "${KDE4_INSTALL_DIR}" AND DEFINED KDE4_${_var})
         set(predefinedvalue "${KDE4_${_var}}")
      endif ("${CMAKE_INSTALL_PREFIX}" STREQUAL "${KDE4_INSTALL_DIR}" AND DEFINED KDE4_${_var})

      if (NOT DEFINED ${_var})
         set(${_var} ${predefinedvalue})
      else (NOT DEFINED ${_var})
         set(${_var} "${${_var}}" CACHE PATH "${_comment}")
      endif (NOT DEFINED ${_var})
   endmacro(_SET_FANCY)

   if(APPLE)
      set(BUNDLE_INSTALL_DIR "/Applications/KDE4" CACHE PATH "Directory where application bundles will be installed to on OSX" )
   endif(APPLE)

   _set_fancy(EXEC_INSTALL_PREFIX  "${CMAKE_INSTALL_PREFIX}"                 "Base directory for executables and libraries")
   _set_fancy(SHARE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/share"           "Base directory for files which go to share/")
   _set_fancy(BIN_INSTALL_DIR      "${EXEC_INSTALL_PREFIX}/bin"              "The install dir for executables (default ${EXEC_INSTALL_PREFIX}/bin)")
   _set_fancy(SBIN_INSTALL_DIR     "${EXEC_INSTALL_PREFIX}/sbin"             "The install dir for system executables (default ${EXEC_INSTALL_PREFIX}/sbin)")
   _set_fancy(LIB_INSTALL_DIR      "${EXEC_INSTALL_PREFIX}/lib${LIB_SUFFIX}" "The subdirectory relative to the install prefix where libraries will be installed (default is ${EXEC_INSTALL_PREFIX}/lib${LIB_SUFFIX})")
   _set_fancy(LIBEXEC_INSTALL_DIR  "${LIB_INSTALL_DIR}/kde4/libexec"         "The subdirectory relative to the install prefix where libraries will be installed (default is ${LIB_INSTALL_DIR}/kde4/libexec)")
   _set_fancy(INCLUDE_INSTALL_DIR  "${CMAKE_INSTALL_PREFIX}/include"         "The subdirectory to the header prefix")

   _set_fancy(PLUGIN_INSTALL_DIR       "${LIB_INSTALL_DIR}/kde4"                "The subdirectory relative to the install prefix where plugins will be installed (default is ${LIB_INSTALL_DIR}/kde4)")
   _set_fancy(IMPORTS_INSTALL_DIR       "${PLUGIN_INSTALL_DIR}/imports"                "The subdirectory relative to the install prefix where imports will be installed")
   _set_fancy(CONFIG_INSTALL_DIR       "${SHARE_INSTALL_PREFIX}/config"         "The config file install dir")
   _set_fancy(DATA_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/apps"           "The parent directory where applications can install their data")
   _set_fancy(HTML_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/doc/HTML"       "The HTML install dir for documentation")
   _set_fancy(ICON_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/icons"          "The icon install dir (default ${SHARE_INSTALL_PREFIX}/share/icons/)")
   _set_fancy(KCFG_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/config.kcfg"    "The install dir for kconfig files")
   _set_fancy(LOCALE_INSTALL_DIR       "${SHARE_INSTALL_PREFIX}/locale"         "The install dir for translations")
   _set_fancy(MIME_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/mimelnk"        "The install dir for the mimetype desktop files")
   _set_fancy(SERVICES_INSTALL_DIR     "${SHARE_INSTALL_PREFIX}/kde4/services"  "The install dir for service (desktop, protocol, ...) files")
   _set_fancy(SERVICETYPES_INSTALL_DIR "${SHARE_INSTALL_PREFIX}/kde4/servicetypes" "The install dir for servicestypes desktop files")
   _set_fancy(SOUND_INSTALL_DIR        "${SHARE_INSTALL_PREFIX}/sounds"         "The install dir for sound files")
   _set_fancy(TEMPLATES_INSTALL_DIR    "${SHARE_INSTALL_PREFIX}/templates"      "The install dir for templates (Create new file...)")
   _set_fancy(WALLPAPER_INSTALL_DIR    "${SHARE_INSTALL_PREFIX}/wallpapers"     "The install dir for wallpapers")
   _set_fancy(DEMO_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/demos"          "The install dir for demos")
   _set_fancy(KCONF_UPDATE_INSTALL_DIR "${DATA_INSTALL_DIR}/kconf_update"       "The kconf_update install dir")
   _set_fancy(AUTOSTART_INSTALL_DIR    "${SHARE_INSTALL_PREFIX}/autostart"      "The install dir for autostart files")

   _set_fancy(XDG_APPS_INSTALL_DIR     "${SHARE_INSTALL_PREFIX}/applications/kde4"         "The XDG apps dir")
   _set_fancy(XDG_DIRECTORY_INSTALL_DIR "${SHARE_INSTALL_PREFIX}/desktop-directories"      "The XDG directory")
   _set_fancy(XDG_MIME_INSTALL_DIR     "${SHARE_INSTALL_PREFIX}/mime/packages"  "The install dir for the xdg mimetypes")

   _set_fancy(SYSCONF_INSTALL_DIR      "${CMAKE_INSTALL_PREFIX}/etc"            "The sysconfig install dir (default ${CMAKE_INSTALL_PREFIX}/etc)")
   _set_fancy(MAN_INSTALL_DIR          "${SHARE_INSTALL_PREFIX}/man"            "The man install dir (default ${SHARE_INSTALL_PREFIX}/man/)")
   _set_fancy(INFO_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/info"           "The info install dir (default ${SHARE_INSTALL_PREFIX}/info)")
   _set_fancy(DBUS_INTERFACES_INSTALL_DIR      "${SHARE_INSTALL_PREFIX}/dbus-1/interfaces" "The dbus interfaces install dir (default  ${SHARE_INSTALL_PREFIX}/dbus-1/interfaces)")
   _set_fancy(DBUS_SERVICES_INSTALL_DIR      "${SHARE_INSTALL_PREFIX}/dbus-1/services"     "The dbus services install dir (default  ${SHARE_INSTALL_PREFIX}/dbus-1/services)")
   _set_fancy(DBUS_SYSTEM_SERVICES_INSTALL_DIR      "${SHARE_INSTALL_PREFIX}/dbus-1/system-services"     "The dbus system services install dir (default  ${SHARE_INSTALL_PREFIX}/dbus-1/system-services)")

endif (WIN32)


# For more documentation see above.
# Later on it will be possible to extend this for installing OSX frameworks
# The COMPONENT Devel argument has the effect that static libraries belong to the
# "Devel" install component. If we use this also for all install() commands
# for header files, it will be possible to install
#   -everything: make install OR cmake -P cmake_install.cmake
#   -only the development files: cmake -DCOMPONENT=Devel -P cmake_install.cmake
#   -everything except the development files: cmake -DCOMPONENT=Unspecified -P cmake_install.cmake
# This can then also be used for packaging with cpack.
set(INSTALL_TARGETS_DEFAULT_ARGS  RUNTIME DESTINATION "${BIN_INSTALL_DIR}"
                                  LIBRARY DESTINATION "${LIB_INSTALL_DIR}"
                                  ARCHIVE DESTINATION "${LIB_INSTALL_DIR}" COMPONENT Devel )


# on the Mac support an extra install directory for application bundles starting with cmake 2.6
if(APPLE)
   set(INSTALL_TARGETS_DEFAULT_ARGS  ${INSTALL_TARGETS_DEFAULT_ARGS}
                               BUNDLE DESTINATION "${BUNDLE_INSTALL_DIR}" )
endif(APPLE)


##############  add some more default search paths  ###############
#
# the KDE4_xxx_INSTALL_DIR variables are empty when building kdelibs itself
# and otherwise point to the kde4 install dirs

set(CMAKE_SYSTEM_INCLUDE_PATH ${CMAKE_SYSTEM_INCLUDE_PATH}
                              "${KDE4_INCLUDE_INSTALL_DIR}")

set(CMAKE_SYSTEM_PROGRAM_PATH ${CMAKE_SYSTEM_PROGRAM_PATH}
                              "${KDE4_BIN_INSTALL_DIR}" )

set(CMAKE_SYSTEM_LIBRARY_PATH ${CMAKE_SYSTEM_LIBRARY_PATH}
                              "${KDE4_LIB_INSTALL_DIR}" )

# under Windows dlls may be also installed in bin/
if(WIN32)
  set(CMAKE_SYSTEM_LIBRARY_PATH ${CMAKE_SYSTEM_LIBRARY_PATH}
                                "${_CMAKE_INSTALL_DIR}/bin"
                                "${CMAKE_INSTALL_PREFIX}/bin" )
endif(WIN32)


######################################################
#  and now the platform specific stuff
######################################################

# Set a default build type for single-configuration
# CMake generators if no build type is set.
if (NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE RelWithDebInfo)
endif (NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)


if (WIN32)

   if(CYGWIN)
      message(FATAL_ERROR "Cygwin is NOT supported, use mingw or MSVC to build KDE4.")
   endif(CYGWIN)

   # limit win32 packaging to kdelibs at now
   # don't know if package name, version and notes are always available
   if(_kdeBootStrapping)
      find_package(KDEWIN_Packager)
      if (KDEWIN_PACKAGER_FOUND)
         kdewin_packager("kdelibs" "${KDE_VERSION}" "KDE base library" "")
      endif (KDEWIN_PACKAGER_FOUND)

      include(Win32Macros)
      addExplorerWrapper("kdelibs")
   endif(_kdeBootStrapping)

   set( _KDE4_PLATFORM_INCLUDE_DIRS ${KDEWIN_INCLUDES})

   # if we are compiling kdelibs, add KDEWIN_LIBRARIES explicitly,
   # otherwise they come from KDELibsDependencies.cmake, Alex
   if (_kdeBootStrapping)
      set( KDE4_KDECORE_LIBS ${KDE4_KDECORE_LIBS} ${KDEWIN_LIBRARIES} )
   endif (_kdeBootStrapping)

   # we prefer to use a different postfix for debug libs only on Windows
   # does not work atm
   set(CMAKE_DEBUG_POSTFIX "")

   # windows, microsoft compiler
   if(MSVC OR (WIN32 AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel"))
      set( _KDE4_PLATFORM_DEFINITIONS -DKDE_FULL_TEMPLATE_EXPORT_INSTANTIATION -DWIN32_LEAN_AND_MEAN )

      # C4250: 'class1' : inherits 'class2::member' via dominance
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4250" )
      # C4251: 'identifier' : class 'type' needs to have dll-interface to be used by clients of class 'type2'
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4251" )
      # C4396: 'identifier' : 'function' the inline specifier cannot be used when a friend declaration refers to a specialization of a function template
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4396" )
      # to avoid a lot of deprecated warnings
      add_definitions( -D_CRT_SECURE_NO_DEPRECATE
                       -D_CRT_SECURE_NO_WARNINGS
                       -D_CRT_NONSTDC_NO_DEPRECATE
                       -D_SCL_SECURE_NO_WARNINGS
                       )
      # 'identifier' : no suitable definition provided for explicit template instantiation request
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4661" )
   endif(MSVC OR (WIN32 AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel"))


   # for visual studio IDE set the path correctly for custom commands
   # maybe under windows bat-files should be generated for running apps during the build
   if(MSVC_IDE)
     get_filename_component(PERL_LOCATION "${PERL_EXECUTABLE}" PATH)
     file(TO_NATIVE_PATH "${PERL_LOCATION}" PERL_PATH_WINDOWS)
     file(TO_NATIVE_PATH "${QT_BINARY_DIR}" QT_BIN_DIR_WINDOWS)
     set(CMAKE_MSVCIDE_RUN_PATH "${PERL_PATH_WINDOWS}\;${QT_BIN_DIR_WINDOWS}"
       CACHE STATIC "MSVC IDE Run path" FORCE)
   endif(MSVC_IDE)

   # we don't support anything below w2k and all winapi calls are unicodes
   set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_WIN32_WINNT=0x0501 -DWINVER=0x0501 -D_WIN32_IE=0x0501 -DUNICODE" )
endif (WIN32)


# setup default RPATH/install_name handling, may be overridden by KDE4_HANDLE_RPATH_FOR_EXECUTABLE
# It sets up to build with full RPATH. When installing, RPATH will be changed to the LIB_INSTALL_DIR
# and all link directories which are not inside the current build dir.
if (UNIX)
   set( _KDE4_PLATFORM_INCLUDE_DIRS)

   # the rest is RPATH handling
   # here the defaults are set
   # which are partly overwritten in kde4_handle_rpath_for_library()
   # and kde4_handle_rpath_for_executable(), both located in KDE4Macros.cmake, Alex
   if (APPLE)
      set(CMAKE_INSTALL_NAME_DIR ${LIB_INSTALL_DIR})
   else (APPLE)
      # add our LIB_INSTALL_DIR to the RPATH (but only when it is not one of the standard system link
      # directories listed in CMAKE_{PLATFORM,C,CXX}_IMPLICIT_LINK_DIRECTORIES) and use the RPATH figured out by cmake when compiling

      list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${LIB_INSTALL_DIR}" _isSystemPlatformLibDir)
      list(FIND CMAKE_C_IMPLICIT_LINK_DIRECTORIES "${LIB_INSTALL_DIR}" _isSystemCLibDir)
      list(FIND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "${LIB_INSTALL_DIR}" _isSystemCxxLibDir)
      if("${_isSystemPlatformLibDir}" STREQUAL "-1" AND "${_isSystemCLibDir}" STREQUAL "-1" AND "${_isSystemCxxLibDir}" STREQUAL "-1")
         set(CMAKE_INSTALL_RPATH "${LIB_INSTALL_DIR}")
      endif("${_isSystemPlatformLibDir}" STREQUAL "-1" AND "${_isSystemCLibDir}" STREQUAL "-1" AND "${_isSystemCxxLibDir}" STREQUAL "-1")

      set(CMAKE_SKIP_BUILD_RPATH FALSE)
      set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
      set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
   endif (APPLE)
endif (UNIX)


if (Q_WS_X11)
   # Done by FindQt4.cmake already
   #find_package(X11 REQUIRED)
   # UNIX has already set _KDE4_PLATFORM_INCLUDE_DIRS, so append
   set(_KDE4_PLATFORM_INCLUDE_DIRS ${_KDE4_PLATFORM_INCLUDE_DIRS} ${X11_INCLUDE_DIR} )
endif (Q_WS_X11)


# This will need to be modified later to support either Qt/X11 or Qt/Mac builds
if (APPLE)

  set ( _KDE4_PLATFORM_DEFINITIONS -D__APPLE_KDE__ )

  # we need to set MACOSX_DEPLOYMENT_TARGET to (I believe) at least 10.2 or maybe 10.3 to allow
  # -undefined dynamic_lookup; in the future we should do this programmatically
  # hmm... why doesn't this work?
  set (ENV{MACOSX_DEPLOYMENT_TARGET} 10.3)

  # "-undefined dynamic_lookup" means we don't care about missing symbols at link-time by default
  # this is bad, but unavoidable until there is the equivalent of libtool -no-undefined implemented
  # or perhaps it already is, and I just don't know where to look  ;)

  set (CMAKE_SHARED_LINKER_FLAGS "-single_module -multiply_defined suppress ${CMAKE_SHARED_LINKER_FLAGS}")
  set (CMAKE_MODULE_LINKER_FLAGS "-multiply_defined suppress ${CMAKE_MODULE_LINKER_FLAGS}")
  #set(CMAKE_SHARED_LINKER_FLAGS "-single_module -undefined dynamic_lookup -multiply_defined suppress")
  #set(CMAKE_MODULE_LINKER_FLAGS "-undefined dynamic_lookup -multiply_defined suppress")

  # we profile...
  if(CMAKE_BUILD_TYPE_TOLOWER MATCHES profile)
    set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
    set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
  endif(CMAKE_BUILD_TYPE_TOLOWER MATCHES profile)

  # removed -Os, was there a special reason for using -Os instead of -O2 ?, Alex
  # optimization flags are set below for the various build types
  set (CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -fno-common")
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-common")
endif (APPLE)


if (CMAKE_SYSTEM_NAME MATCHES Linux OR CMAKE_SYSTEM_NAME STREQUAL GNU)
   if (CMAKE_COMPILER_IS_GNUCXX OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
      set ( _KDE4_PLATFORM_DEFINITIONS -D_XOPEN_SOURCE=500 -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_GNU_SOURCE)
      set ( CMAKE_SHARED_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_SHARED_LINKER_FLAGS}")
      set ( CMAKE_MODULE_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_MODULE_LINKER_FLAGS}")

      set ( CMAKE_SHARED_LINKER_FLAGS "-Wl,--enable-new-dtags ${CMAKE_SHARED_LINKER_FLAGS}")
      set ( CMAKE_MODULE_LINKER_FLAGS "-Wl,--enable-new-dtags ${CMAKE_MODULE_LINKER_FLAGS}")
      set ( CMAKE_EXE_LINKER_FLAGS "-Wl,--enable-new-dtags ${CMAKE_EXE_LINKER_FLAGS}")

      # we profile...
      if(CMAKE_BUILD_TYPE_TOLOWER MATCHES profile)
        set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
        set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
      endif(CMAKE_BUILD_TYPE_TOLOWER MATCHES profile)
   endif (CMAKE_COMPILER_IS_GNUCXX OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
   if (CMAKE_C_COMPILER MATCHES "icc")
      set ( _KDE4_PLATFORM_DEFINITIONS -D_XOPEN_SOURCE=500 -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_GNU_SOURCE)
      set ( CMAKE_SHARED_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_SHARED_LINKER_FLAGS}")
      set ( CMAKE_MODULE_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_MODULE_LINKER_FLAGS}")
   endif (CMAKE_C_COMPILER MATCHES "icc")
endif (CMAKE_SYSTEM_NAME MATCHES Linux OR CMAKE_SYSTEM_NAME STREQUAL GNU)

if (UNIX)
   set ( _KDE4_PLATFORM_DEFINITIONS "${_KDE4_PLATFORM_DEFINITIONS} ")

   check_cxx_source_compiles("
#include <sys/types.h>
 /* Check that off_t can represent 2**63 - 1 correctly.
    We can't simply define LARGE_OFF_T to be 9223372036854775807,
    since some C++ compilers masquerading as C compilers
    incorrectly reject 9223372036854775807.  */
#define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))

  int off_t_is_large[(LARGE_OFF_T % 2147483629 == 721 && LARGE_OFF_T % 2147483647 == 1) ? 1 : -1];
  int main() { return 0; }
" _OFFT_IS_64BIT)

   if (NOT _OFFT_IS_64BIT)
     set ( _KDE4_PLATFORM_DEFINITIONS "${_KDE4_PLATFORM_DEFINITIONS} -D_FILE_OFFSET_BITS=64")
   endif (NOT _OFFT_IS_64BIT)
endif (UNIX)


############################################################
# compiler specific settings
############################################################


# this macro is for internal use only.
macro(KDE_CHECK_FLAG_EXISTS FLAG VAR DOC)
   if(NOT ${VAR} MATCHES "${FLAG}")
      set(${VAR} "${${VAR}} ${FLAG}" CACHE STRING "Flags used by the linker during ${DOC} builds." FORCE)
   endif(NOT ${VAR} MATCHES "${FLAG}")
endmacro(KDE_CHECK_FLAG_EXISTS FLAG VAR)

if (MSVC OR (WIN32 AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel"))
   set (KDE4_ENABLE_EXCEPTIONS -EHsc)

   # Qt disables the native wchar_t type, do it too to avoid linking issues
   set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Zc:wchar_t-" )

   # make sure that no header adds libcmt by default using #pragma comment(lib, "libcmt.lib") as done by mfc/afx.h
   kde_check_flag_exists("/NODEFAULTLIB:libcmt /DEFAULTLIB:msvcrt" CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "Release with Debug Info")
   kde_check_flag_exists("/NODEFAULTLIB:libcmt /DEFAULTLIB:msvcrt" CMAKE_EXE_LINKER_FLAGS_RELEASE "release")
   kde_check_flag_exists("/NODEFAULTLIB:libcmt /DEFAULTLIB:msvcrt" CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "release minsize")
   kde_check_flag_exists("/NODEFAULTLIB:libcmtd /DEFAULTLIB:msvcrtd" CMAKE_EXE_LINKER_FLAGS_DEBUG "debug")
endif(MSVC OR (WIN32 AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel"))

# This macro is for internal use only
# Return the directories present in gcc's include path.
macro(_DETERMINE_GCC_SYSTEM_INCLUDE_DIRS _lang _result)
  set(${_result})
  set(_gccOutput)
  file(WRITE "${CMAKE_BINARY_DIR}/CMakeFiles/dummy" "\n" )
  execute_process(COMMAND ${CMAKE_C_COMPILER} -v -E -x ${_lang} -dD dummy
                  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/CMakeFiles
                  ERROR_VARIABLE _gccOutput
                  OUTPUT_VARIABLE _gccStdout )
  file(REMOVE "${CMAKE_BINARY_DIR}/CMakeFiles/dummy")

  if( "${_gccOutput}" MATCHES "> search starts here[^\n]+\n *(.+) *\n *End of (search) list" )
    SET(${_result} ${CMAKE_MATCH_1})
    STRING(REPLACE "\n" " " ${_result} "${${_result}}")
    SEPARATE_ARGUMENTS(${_result})
  ENDIF( "${_gccOutput}" MATCHES "> search starts here[^\n]+\n *(.+) *\n *End of (search) list" )
ENDMACRO(_DETERMINE_GCC_SYSTEM_INCLUDE_DIRS _lang)

if (CMAKE_COMPILER_IS_GNUCC OR CMAKE_C_COMPILER_ID MATCHES Clang)
   _DETERMINE_GCC_SYSTEM_INCLUDE_DIRS(c _dirs)
   set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES
       ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES} ${_dirs})
endif (CMAKE_COMPILER_IS_GNUCC OR CMAKE_C_COMPILER_ID MATCHES Clang)

if (CMAKE_COMPILER_IS_GNUCXX)
   _DETERMINE_GCC_SYSTEM_INCLUDE_DIRS(c++ _dirs)
   set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES
       ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES} ${_dirs})

   set (KDE4_ENABLE_EXCEPTIONS "-fexceptions -UQT_NO_EXCEPTIONS")
   # Select flags.
   set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_CXX_FLAGS_RELEASE        "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_CXX_FLAGS_DEBUG          "-g -O2 -fno-reorder-blocks -fno-schedule-insns -fno-inline")
   set(CMAKE_CXX_FLAGS_DEBUGFULL      "-g3 -fno-inline")
   set(CMAKE_CXX_FLAGS_PROFILE        "-g3 -fno-inline -ftest-coverage -fprofile-arcs")
   set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_C_FLAGS_RELEASE          "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_C_FLAGS_DEBUG            "-g -O2 -fno-reorder-blocks -fno-schedule-insns -fno-inline")
   set(CMAKE_C_FLAGS_DEBUGFULL        "-g3 -fno-inline")
   set(CMAKE_C_FLAGS_PROFILE          "-g3 -fno-inline -ftest-coverage -fprofile-arcs")

   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wno-long-long -std=iso9899:1990 -Wundef -Wcast-align -Werror-implicit-function-declaration -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -Wformat-security -Wmissing-format-attribute -fno-common")
   # As of Qt 4.6.x we need to override the new exception macros if we want compile with -fno-exceptions
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-long-long -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -fno-exceptions -DQT_NO_EXCEPTIONS -fno-check-new -fno-common")

   if (CMAKE_SYSTEM_NAME MATCHES Linux OR CMAKE_SYSTEM_NAME STREQUAL GNU)
     # This should not be needed, as it is also part of _KDE4_PLATFORM_DEFINITIONS below.
     # It is kept here nonetheless both for backwards compatibility in case one does not use add_definitions(${KDE4_DEFINITIONS})
     # and also because it is/was needed by glibc for snprintf to be available when building C files.
     # See commit 4a44862b2d178c1d2e1eb4da90010d19a1e4a42c.
     add_definitions (-D_DEFAULT_SOURCE -D_BSD_SOURCE)
   endif (CMAKE_SYSTEM_NAME MATCHES Linux OR CMAKE_SYSTEM_NAME STREQUAL GNU)

   if (CMAKE_SYSTEM_NAME STREQUAL GNU)
      set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -pthread")
      set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -pthread")
   endif (CMAKE_SYSTEM_NAME STREQUAL GNU)

   # gcc under Windows
   if (MINGW)
      set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--export-all-symbols")
      set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--export-all-symbols")
   endif (MINGW)

   check_cxx_compiler_flag(-fPIE HAVE_FPIE_SUPPORT)
   if(KDE4_ENABLE_FPIE)
       if(HAVE_FPIE_SUPPORT)
        set (KDE4_CXX_FPIE_FLAGS "-fPIE")
        set (KDE4_PIE_LDFLAGS "-pie")
       else(HAVE_FPIE_SUPPORT)
        message(STATUS "Your compiler doesn't support the PIE flag")
       endif(HAVE_FPIE_SUPPORT)
   endif(KDE4_ENABLE_FPIE)

   check_cxx_compiler_flag(-Woverloaded-virtual __KDE_HAVE_W_OVERLOADED_VIRTUAL)
   if(__KDE_HAVE_W_OVERLOADED_VIRTUAL)
       set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Woverloaded-virtual")
   endif(__KDE_HAVE_W_OVERLOADED_VIRTUAL)

   # visibility support
   #check_cxx_compiler_flag(-fvisibility=hidden __KDE_HAVE_GCC_VISIBILITY)
   #set( __KDE_HAVE_GCC_VISIBILITY ${__KDE_HAVE_GCC_VISIBILITY} CACHE BOOL "GCC support for hidden visibility")
   set( __KDE_HAVE_GCC_VISIBILITY 0 CACHE BOOL "GCC support for hidden visibility")
   message(STATUS "__KDE_HAVE_GCC_VISIBILITY=${__KDE_HAVE_GCC_VISIBILITY}")

   # get the gcc version
   exec_program(${CMAKE_C_COMPILER} ARGS ${CMAKE_C_COMPILER_ARG1} --version OUTPUT_VARIABLE _gcc_version_info)

   string (REGEX MATCH "[3-9]\\.[0-9]\\.[0-9]" _gcc_version "${_gcc_version_info}")
   # gcc on mac just reports: "gcc (GCC) 3.3 20030304 ..." without the patch level, handle this here:
   if (NOT _gcc_version)
      string (REGEX MATCH ".*\\(GCC\\).* ([34]\\.[0-9]) .*" "\\1.0" _gcc_version "${gcc_on_macos}")
      if (gcc_on_macos)
        string (REGEX REPLACE ".*\\(GCC\\).* ([34]\\.[0-9]) .*" "\\1.0" _gcc_version "${_gcc_version_info}")
      endif (gcc_on_macos)
   endif (NOT _gcc_version)

   if (_gcc_version)
      macro_ensure_version("4.1.0" "${_gcc_version}" GCC_IS_NEWER_THAN_4_1)
      macro_ensure_version("4.2.0" "${_gcc_version}" GCC_IS_NEWER_THAN_4_2)
      macro_ensure_version("4.3.0" "${_gcc_version}" GCC_IS_NEWER_THAN_4_3)
   endif (_gcc_version)

   # save a little by making local statics not threadsafe
   # ### do not enable it for older compilers, see
   # ### http://gcc.gnu.org/bugzilla/show_bug.cgi?id=31806
   if (GCC_IS_NEWER_THAN_4_3)
       set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-threadsafe-statics")
   endif (GCC_IS_NEWER_THAN_4_3)

   set(_GCC_COMPILED_WITH_BAD_ALLOCATOR FALSE)
   if (GCC_IS_NEWER_THAN_4_1)
      exec_program(${CMAKE_C_COMPILER} ARGS ${CMAKE_C_COMPILER_ARG1} -v OUTPUT_VARIABLE _gcc_alloc_info)
      string(REGEX MATCH "(--enable-libstdcxx-allocator=mt)" _GCC_COMPILED_WITH_BAD_ALLOCATOR "${_gcc_alloc_info}")
   endif (GCC_IS_NEWER_THAN_4_1)

   if (__KDE_HAVE_GCC_VISIBILITY AND GCC_IS_NEWER_THAN_4_1 AND NOT _GCC_COMPILED_WITH_BAD_ALLOCATOR AND NOT WIN32)
      set(_include_dirs "-DINCLUDE_DIRECTORIES:STRING=${QT_INCLUDES}")

      # first check if we can compile a Qt application
      set(_source "#include <QtCore/QtGlobal>\n int main() \n {\n return 0; \n } \n")
      set(_source_file ${CMAKE_BINARY_DIR}/CMakeTmp/check_qt_application.cpp)
      file(WRITE "${_source_file}" "${_source}")

      try_compile(_basic_compile_result ${CMAKE_BINARY_DIR} ${_source_file} CMAKE_FLAGS "${_include_dirs}" OUTPUT_VARIABLE _compile_output_var)

      if(_basic_compile_result)
#            # now ready to check for visibility=hidden
#            set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
#            set (KDE4_C_FLAGS "-fvisibility=hidden")
#            # check that Qt defines Q_DECL_EXPORT as __attribute__ ((visibility("default")))
#            # if it doesn't and KDE compiles with hidden default visibiltiy plugins will break
#            set(_source "#include <QtCore/QtGlobal>\n int main()\n {\n #ifndef QT_VISIBILITY_AVAILABLE \n #error QT_VISIBILITY_AVAILABLE is not available\n #endif \n }\n")
#            set(_source_file ${CMAKE_BINARY_DIR}/CMakeTmp/check_qt_visibility.cpp)
#            file(WRITE "${_source_file}" "${_source}")
#
#            try_compile(_compile_result ${CMAKE_BINARY_DIR} ${_source_file} CMAKE_FLAGS "${_include_dirs}" OUTPUT_VARIABLE _compile_output_var)
#
#            if(NOT _compile_result)
#               message("${_compile_output_var}")
#               message(FATAL_ERROR "Qt compiled without support for -fvisibility=hidden. This will break plugins and linking of some applications. Please fix your Qt installation (try passing --reduce-exports to configure).")
#            endif(NOT _compile_result)
       else(_basic_compile_result)
         message("${_compile_output_var}")
         message(FATAL_ERROR "Unable to compile a basic Qt application. Qt has not been found correctly.")
       endif(_basic_compile_result)

      if (GCC_IS_NEWER_THAN_4_2)
         set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror=return-type -fvisibility-inlines-hidden")
      endif (GCC_IS_NEWER_THAN_4_2)
   else (__KDE_HAVE_GCC_VISIBILITY AND GCC_IS_NEWER_THAN_4_1 AND NOT _GCC_COMPILED_WITH_BAD_ALLOCATOR AND NOT WIN32)
	 message(WARNING "Turning off hidden visibility")
      set (__KDE_HAVE_GCC_VISIBILITY 0)
   endif (__KDE_HAVE_GCC_VISIBILITY AND GCC_IS_NEWER_THAN_4_1 AND NOT _GCC_COMPILED_WITH_BAD_ALLOCATOR AND NOT WIN32)

endif (CMAKE_COMPILER_IS_GNUCXX)


# Detect Clang the proper way (= including AppleClang)
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
   _DETERMINE_GCC_SYSTEM_INCLUDE_DIRS(c++ _dirs)
   set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES
       ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES} ${_dirs})

   # Note that exceptions are enabled by default when building with clang. That
   # is, -fno-exceptions is not set in CMAKE_CXX_FLAGS below. This is because a
   # lot of code in different KDE modules ends up including code that throws
   # exceptions. Most (or all) of the occurrences are in template code that
   # never gets instantiated. Contrary to GCC, ICC and MSVC, clang (most likely
   # rightfully) complains about that. Trying to work around the issue by
   # passing -fdelayed-template-parsing brings other problems, as noted in
   # http://lists.kde.org/?l=kde-core-devel&m=138157459706783&w=2.
   # The generated code will be slightly bigger, but there is no way to avoid
   # it.
   set(KDE4_ENABLE_EXCEPTIONS "-fexceptions -UQT_NO_EXCEPTIONS")

   # Select flags.
   set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_CXX_FLAGS_RELEASE        "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_CXX_FLAGS_DEBUG          "-g -O2 -fno-inline")
   set(CMAKE_CXX_FLAGS_DEBUGFULL      "-g3 -fno-inline")
   set(CMAKE_CXX_FLAGS_PROFILE        "-g3 -fno-inline -ftest-coverage -fprofile-arcs")
   set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_C_FLAGS_RELEASE          "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_C_FLAGS_DEBUG            "-g -O2 -fno-inline")
   set(CMAKE_C_FLAGS_DEBUGFULL        "-g3 -fno-inline")
   set(CMAKE_C_FLAGS_PROFILE          "-g3 -fno-inline -ftest-coverage -fprofile-arcs")

   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wno-long-long -std=iso9899:1990 -Wundef -Wcast-align -Werror-implicit-function-declaration -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -Wformat-security -Wmissing-format-attribute -fno-common")
   #set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-long-long -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -Woverloaded-virtual -fno-common -fvisibility=hidden -Werror=return-type -fvisibility-inlines-hidden")
   #set(KDE4_C_FLAGS    "-fvisibility=hidden")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-long-long -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -Woverloaded-virtual -fno-common -Werror=return-type")
   set(KDE4_C_FLAGS    "")

   # At least kdepim exports one function with C linkage that returns a
   # QString in a plugin, but clang does not like that.
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-return-type-c-linkage")

   set(KDE4_CXX_FPIE_FLAGS "-fPIE")
   set(KDE4_PIE_LDFLAGS    "-pie")

   if (CMAKE_SYSTEM_NAME STREQUAL GNU)
      set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -pthread")
      set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -pthread")
   endif (CMAKE_SYSTEM_NAME STREQUAL GNU)

   message(STATUS "Building with Clang but no hidden visibility")
   set(__KDE_HAVE_GCC_VISIBILITY FALSE)

   # check that Qt defines Q_DECL_EXPORT as __attribute__ ((visibility("default")))
   # if it doesn't and KDE compiles with hidden default visibiltiy plugins will break
#   set(_source "#include <QtCore/QtGlobal>\n int main()\n {\n #ifndef QT_VISIBILITY_AVAILABLE \n #error QT_VISIBILITY_AVAILABLE is not available\n #endif \n }\n")
#   set(_source_file ${CMAKE_BINARY_DIR}/CMakeTmp/check_qt_visibility.cpp)
#   file(WRITE "${_source_file}" "${_source}")
#   set(_include_dirs "-DINCLUDE_DIRECTORIES:STRING=${QT_INCLUDES}")
#   try_compile(_compile_result ${CMAKE_BINARY_DIR} ${_source_file} CMAKE_FLAGS "${_include_dirs}" OUTPUT_VARIABLE _compile_output_var)
#   if(NOT _compile_result)
#       message("${_compile_output_var}")
#       message(FATAL_ERROR "Qt compiled without support for -fvisibility=hidden. This will break plugins and linking of some applications. Please fix your Qt installation (try passing --reduce-exports to configure).")
#   endif(NOT _compile_result)
endif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")


if (CMAKE_C_COMPILER MATCHES "icc")

   set (KDE4_ENABLE_EXCEPTIONS -fexceptions)
   # Select flags.
   set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g")
   set(CMAKE_CXX_FLAGS_RELEASE        "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_CXX_FLAGS_DEBUG          "-O2 -g -fno-inline -noalign")
   set(CMAKE_CXX_FLAGS_DEBUGFULL      "-g -fno-inline -noalign")
   set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O2 -g")
   set(CMAKE_C_FLAGS_RELEASE          "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_C_FLAGS_DEBUG            "-O2 -g -fno-inline -noalign")
   set(CMAKE_C_FLAGS_DEBUGFULL        "-g -fno-inline -noalign")

   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -ansi -Wall -w1 -Wpointer-arith -fno-common")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ansi -Wall -w1 -Wpointer-arith -fno-exceptions -fno-common")

   # visibility support
   set(__KDE_HAVE_ICC_VISIBILITY)
#   check_cxx_compiler_flag(-fvisibility=hidden __KDE_HAVE_ICC_VISIBILITY)
#   if (__KDE_HAVE_ICC_VISIBILITY)
#      set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
#   endif (__KDE_HAVE_ICC_VISIBILITY)

endif (CMAKE_C_COMPILER MATCHES "icc")


###########    end of platform specific stuff  ##########################


# KDE4Macros.cmake contains all the KDE specific macros
include(${kde_cmake_module_dir}/KDE4Macros.cmake)


# decide whether KDE4 has been found
set(KDE4_FOUND FALSE)
if (KDE4_INCLUDE_DIR AND KDE4_LIB_DIR AND KDE4_KCFGC_EXECUTABLE AND KDE4_INSTALLED_VERSION_OK)
   set(KDE4_FOUND TRUE)
   set(KDE4Internal_FOUND TRUE) # for feature_summary
endif (KDE4_INCLUDE_DIR AND KDE4_LIB_DIR AND KDE4_KCFGC_EXECUTABLE AND KDE4_INSTALLED_VERSION_OK)


macro (KDE4_PRINT_RESULTS)

   # inside kdelibs the include dir and lib dir are internal, not "found"
   if (NOT _kdeBootStrapping)
       if(KDE4_INCLUDE_DIR)
          message(STATUS "Found KDE 4.12 include dir: ${KDE4_INCLUDE_DIR}")
       else(KDE4_INCLUDE_DIR)
          message(STATUS "ERROR: unable to find the KDE 4 headers")
       endif(KDE4_INCLUDE_DIR)

       if(KDE4_LIB_DIR)
          message(STATUS "Found KDE 4.12 library dir: ${KDE4_LIB_DIR}")
       else(KDE4_LIB_DIR)
          message(STATUS "ERROR: unable to find the KDE 4 core library")
       endif(KDE4_LIB_DIR)
   endif (NOT _kdeBootStrapping)

   if(KDE4_KCFGC_EXECUTABLE)
      message(STATUS "Found the KDE4 kconfig_compiler preprocessor: ${KDE4_KCFGC_EXECUTABLE}")
   else(KDE4_KCFGC_EXECUTABLE)
      message(STATUS "Didn't find the KDE4 kconfig_compiler preprocessor")
   endif(KDE4_KCFGC_EXECUTABLE)

   if(AUTOMOC4_EXECUTABLE)
      message(STATUS "Found automoc4: ${AUTOMOC4_EXECUTABLE}")
   else(AUTOMOC4_EXECUTABLE)
      message(STATUS "Didn't find automoc4")
   endif(AUTOMOC4_EXECUTABLE)
endmacro (KDE4_PRINT_RESULTS)


if (KDE4Internal_FIND_REQUIRED AND NOT KDE4_FOUND)
   #bail out if something wasn't found
   kde4_print_results()
   if (NOT KDE4_INSTALLED_VERSION_OK)
     message(FATAL_ERROR "ERROR: the installed kdelibs version ${KDE_VERSION} is too old, at least version ${KDE_MIN_VERSION} is required")
   endif (NOT KDE4_INSTALLED_VERSION_OK)

   if (NOT KDE4_KCFGC_EXECUTABLE)
     message(FATAL_ERROR "ERROR: could not detect a usable kconfig_compiler")
   endif (NOT KDE4_KCFGC_EXECUTABLE)

   message(FATAL_ERROR "ERROR: could NOT find everything required for compiling KDE 4 programs")
endif (KDE4Internal_FIND_REQUIRED AND NOT KDE4_FOUND)

if (NOT KDE4Internal_FIND_QUIETLY)
   kde4_print_results()
endif (NOT KDE4Internal_FIND_QUIETLY)

#add the found Qt and KDE include directories to the current include path
#the ${KDE4_INCLUDE_DIR}/KDE directory is for forwarding includes, eg. #include <KMainWindow>
set(KDE4_INCLUDES
   ${KDE4_INCLUDE_DIR}
   ${KDE4_INCLUDE_DIR}/KDE
   ${KDE4_PHONON_INCLUDES}
   ${QT_INCLUDES}
   ${_KDE4_PLATFORM_INCLUDE_DIRS}
)

# Used by kdebug.h: the "toplevel dir" is one level above CMAKE_SOURCE_DIR
get_filename_component(_KDE4_CMAKE_TOPLEVEL_DIR "${CMAKE_SOURCE_DIR}/.." ABSOLUTE)
string(LENGTH "${_KDE4_CMAKE_TOPLEVEL_DIR}" _KDE4_CMAKE_TOPLEVEL_DIR_LENGTH)

set(KDE4_DEFINITIONS ${_KDE4_PLATFORM_DEFINITIONS} -DQT_NO_STL -DQT_NO_CAST_TO_ASCII -D_REENTRANT -DKDE_DEPRECATED_WARNINGS -DKDE4_CMAKE_TOPLEVEL_DIR_LENGTH=${_KDE4_CMAKE_TOPLEVEL_DIR_LENGTH})

if (NOT _kde4_uninstall_rule_created)
   set(_kde4_uninstall_rule_created TRUE)

   configure_file("${kde_cmake_module_dir}/kde4_cmake_uninstall.cmake.in" "${CMAKE_BINARY_DIR}/cmake_uninstall.cmake" @ONLY)

   add_custom_target(uninstall "${CMAKE_COMMAND}" -P "${CMAKE_BINARY_DIR}/cmake_uninstall.cmake")

endif (NOT _kde4_uninstall_rule_created)

endif(NOT KDE4_FOUND)
