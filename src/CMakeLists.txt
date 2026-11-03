find_package(Eigen3 REQUIRED)

add_library(geoEff SHARED geoEff.cpp)
target_include_directories(geoEff PUBLIC ${CMAKE_SOURCE_DIR}/include)
target_link_libraries(geoEff PUBLIC Eigen3::Eigen)

if(NDGEOEFF_BUILD_PYTHON)
  pybind11_add_module(pyGeoEff pyGeoEff.cpp)
  target_link_libraries(pyGeoEff PRIVATE geoEff)
endif()
