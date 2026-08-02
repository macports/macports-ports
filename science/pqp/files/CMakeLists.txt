cmake_minimum_required(VERSION 2.8)

project(PQP CXX)

file(GLOB PQP_SRC "*.cpp")
add_library(PQP SHARED ${PQP_SRC})
add_library(PQP-static STATIC ${PQP_SRC})
set_target_properties(PQP-static PROPERTIES OUTPUT_NAME "PQP")
install(TARGETS PQP PQP-static DESTINATION lib)
install(FILES BV.h MatVec.h PQP.h PQP_Compile.h PQP_Internal.h Tri.h BVTQ.h Build.h TriDist.h DESTINATION include/PQP)
install(FILES LICENSE DESTINATION share/doc/pqp)
