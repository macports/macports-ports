# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

# - Try to find the proj4 library
# Once done this will define
#
# PROJ4_FOUND - system has proj4
# PROJ4_INCLUDE_DIRS - the proj4 include directory
# PROJ4_LIBRARIES - Link these to use proj4
#
# Define PROJ4_MIN_VERSION for which version desired.

if( NOT PROJ4_PATH )
    if ( NOT "$ENV{PROJ4_PATH}" STREQUAL "" )
        set( PROJ4_PATH "$ENV{PROJ4_PATH}" )
    elseif ( NOT "$ENV{PROJ4_DIR}" STREQUAL "" )
        set( PROJ4_PATH "$ENV{PROJ4_DIR}" )
    endif()
endif()

if( NOT PROJ4_PATH )

    include(FindPkgConfig)

    if(PROJ4_MIN_VERSION)
        pkg_check_modules(PKPROJ4 ${_pkgconfig_REQUIRED} QUIET proj4>=${PROJ4_MIN_VERSION})
    else()
        pkg_check_modules(PKPROJ4 ${_pkgconfig_REQUIRED} QUIET proj4)
    endif()

    if( PKG_CONFIG_FOUND AND PKPROJ4_FOUND )

        find_path(PROJ4_INCLUDE_DIR proj_api.h HINTS ${PKPROJ4_INCLUDEDIR} ${PKPROJ4_INCLUDE_DIRS} PATH_SUFFIXES proj4 NO_DEFAULT_PATH )
        find_library(PROJ4_LIBRARY  proj       HINTS ${PKPROJ4_LIBDIR}     ${PKPROJ4_LIBRARY_DIRS} PATH_SUFFIXES proj4 NO_DEFAULT_PATH )

    endif()

endif()

if( PROJ4_PATH )

    find_path(PROJ4_INCLUDE_DIR NAMES proj_api.h PATHS ${PROJ4_PATH} ${PROJ4_PATH}/include PATH_SUFFIXES proj4 NO_DEFAULT_PATH )
    find_library(PROJ4_LIBRARY  NAMES proj       PATHS ${PROJ4_PATH} ${PROJ4_PATH}/lib     PATH_SUFFIXES proj4 NO_DEFAULT_PATH )

endif()

find_path(PROJ4_INCLUDE_DIR NAMES proj_api.h PATHS PATH_SUFFIXES proj4 )
find_library( PROJ4_LIBRARY NAMES proj       PATHS PATH_SUFFIXES proj4 )


# handle the QUIETLY and REQUIRED arguments and set GRIBAPI_FOUND
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Proj4  DEFAULT_MSG
                                  PROJ4_LIBRARY PROJ4_INCLUDE_DIR)

set( PROJ4_LIBRARIES    ${PROJ4_LIBRARY} )
set( PROJ4_INCLUDE_DIRS ${PROJ4_INCLUDE_DIR} )

mark_as_advanced( PROJ4_INCLUDE_DIR PROJ4_LIBRARY )
