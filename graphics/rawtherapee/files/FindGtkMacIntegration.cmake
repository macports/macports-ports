# Distributed under the OSI-approved BSD 3-Clause License.
# See accompanying file Copyright.txt or https://cmake.org/licensing
# for details.

#[================================================================[.rst:
FindGtkMacIntegration
-------

Finds the native GtkosxApplication library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``gtkmacintegration::gtkmacintegration``
  The gtkmacintegration library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``GtkMacIntegration_FOUND``
  True if the system has the GtkosxApplication library.
``GtkMacIntegration_INCLUDE_DIRS``
  Include directories needed to use GtkosxApplication.
``GtkMacIntegration_LIBRARIES``
  Libraries needed to link to GtkosxApplication.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``GtkMacIntegration_INCLUDE_DIR``
  The directory containing ``gtkosxapplication.h``.
``GtkMacIntegration_LIBRARY``
  The path to the GtkosxApplication library.

#]================================================================]

# The following code was adapted from the instructions provided at
# https://cmake.org/cmake/help/latest/manual/cmake-developer.7.html

set(MACINTEGRATION_NAMES ${MACINTEGRATION_NAMES}
  gtkmacintegration      libgtkmacintegration
  gtkmacintegration-gtk3 libgtkmacintegration-gtk3
)

find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
  pkg_check_modules(PC_GtkMacIntegration QUIET gtk-mac-integration-gtk3)
  find_path(GtkMacIntegration_INCLUDE_DIR
    NAMES gtkosxapplication.h
    PATHS ${PC_GtkMacIntegration_INCLUDE_DIRS}
  )
  find_library(GtkMacIntegration_LIBRARY
    NAMES ${MACINTEGRATION_NAMES}
    PATHS ${PC_GtkMacIntegration_LIBRARY_DIRS}
  )
else()
  find_path(GtkMacIntegration_INCLUDE_DIR
    NAMES gtkosxapplication.h
    PATH_SUFFIXES gtkmacintegration gtkmacintegration-gtk3
  )
  find_library(GtkMacIntegration_LIBRARY NAMES ${MACINTEGRATION_NAMES})
endif(PkgConfig_FOUND)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GtkMacIntegration
  FOUND_VAR GtkMacIntegration_FOUND
  REQUIRED_VARS
    GtkMacIntegration_LIBRARY
    GtkMacIntegration_INCLUDE_DIR
)

if(GtkMacIntegration_FOUND
  AND NOT TARGET gtkmacintegration::gtkmacintegration
)
  set(GtkMacIntegration_INCLUDE_DIRS ${GtkMacIntegration_INCLUDE_DIR})
  set(GtkMacIntegration_LIBRARIES ${GtkMacIntegration_LIBRARY})

  add_library(gtkmacintegration::gtkmacintegration UNKNOWN IMPORTED)
  set_target_properties(gtkmacintegration::gtkmacintegration PROPERTIES
    IMPORTED_LOCATION "${GtkMacIntegration_LIBRARY}"
    INTERFACE_COMPILE_OPTIONS "${PC_GtkMacIntegration_CFLAGS_OTHER}"
    INTERFACE_INCLUDE_DIRECTORIES "${GtkMacIntegration_INCLUDE_DIR}"
  )
endif()

mark_as_advanced(
  GtkMacIntegration_INCLUDE_DIR
  GtkMacIntegration_LIBRARY
)
