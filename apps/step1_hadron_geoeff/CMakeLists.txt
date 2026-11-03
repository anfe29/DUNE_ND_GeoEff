find_package(ROOT)

if(ROOT_FOUND)
  set(EDEPSIM_ROOT_FILE ${CMAKE_CURRENT_SOURCE_DIR}/EDepSimForMakeProject_20200424.root)
  set(EDEPSIM_ROOT_MAKE_PROJECT_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/makeEDepSimProject.C)
  set(EDEPSIM_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR}/EDepSimEvents)
  set(EDEPSIM_LIB ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libEDepSimEvents.so)
  set(EDEPSIM_HEADER_DIR ${CMAKE_BINARY_DIR}/include)

  add_custom_command(
    OUTPUT ${EDEPSIM_LIB}
    COMMAND root -b -q ${EDEPSIM_ROOT_FILE} ${EDEPSIM_ROOT_MAKE_PROJECT_SCRIPT}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${EDEPSIM_HEADER_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${EDEPSIM_BUILD_DIR}/EDepSimEvents.so ${EDEPSIM_LIB}
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${EDEPSIM_BUILD_DIR} ${EDEPSIM_HEADER_DIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS ${EDEPSIM_ROOT_FILE} ${EDEPSIM_ROOT_MAKE_PROJECT_SCRIPT}
    COMMENT "Generating EDepSimEvents library and headers"
  )

  add_custom_target(compile_EDepSimEvents DEPENDS ${EDEPSIM_LIB})

  add_library(EDepSimEvents SHARED IMPORTED)
  set_property(TARGET EDepSimEvents PROPERTY IMPORTED_LOCATION ${EDEPSIM_LIB})
  set_property(TARGET EDepSimEvents PROPERTY IMPORTED_NO_SONAME TRUE)
  add_dependencies(EDepSimEvents compile_EDepSimEvents)
  link_directories(${CMAKE_LIBRARY_OUTPUT_DIRECTORY})

  add_executable(runGeoEffEDepSimBeamDir runGeoEffEDepSimBeamDir.cpp)
  add_executable(runGeoEffFDEvtSim runGeoEffFDEvtSim.cpp)

  foreach(target runGeoEffEDepSimBeamDir runGeoEffFDEvtSim)
    target_include_directories(${target} PRIVATE
      ${CMAKE_CURRENT_SOURCE_DIR}
      ${CMAKE_BINARY_DIR}/include
      ${ROOT_INCLUDE_DIRS}
    )
    target_link_libraries(${target} PRIVATE geoEff ${ROOT_LIBRARIES})
  endforeach()

  target_link_libraries(runGeoEffEDepSimBeamDir PRIVATE EDepSimEvents)
else()
  message(WARNING "ROOT not found. Skipping step 1 hadron geometric efficiency apps.")
endif()
