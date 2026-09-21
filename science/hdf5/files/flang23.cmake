if(CMAKE_Fortran_COMPILER_ID MATCHES "LLVMFlang|Flang")
    find_library(FLANG_RT_LIB
        NAMES flang_rt.runtime
        PATHS ${FLANG_RT_LIBDIR}
        REQUIRED
    )

    set(CMAKE_Fortran_LINK_EXECUTABLE
        "${CMAKE_C_LINK_EXECUTABLE} ${FLANG_RT_LIB}")
    set(CMAKE_Fortran_CREATE_SHARED_LIBRARY
        "${CMAKE_C_CREATE_SHARED_LIBRARY} ${FLANG_RT_LIB}")
endif()
