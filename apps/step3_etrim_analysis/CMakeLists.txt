find_package(ROOT)

if(NOT ROOT_FOUND)
  message(WARNING "ROOT not found. Skipping step 3 Etrim analysis apps.")
  return()
endif()

find_path(OSCLIB_INCLUDE_DIR OscLib/OscCalcPMNSOpt.h
  HINTS $ENV{OSCLIB_INC} $ENV{OSCLIB_ROOT}/include)
find_library(OSCLIB_LIBRARY NAMES OscLib
  HINTS $ENV{OSCLIB_LIB} $ENV{OSCLIB_ROOT}/lib)

set(STEP3_NOOSC_APP
  NtupleOutVetoAndTrimE_AssumeEqualEffAtAllOA_NOOscSpectrumNOCAFAna_FDRateAtND)

add_executable(${STEP3_NOOSC_APP} ${STEP3_NOOSC_APP}.C)
set_source_files_properties(${STEP3_NOOSC_APP}.C PROPERTIES LANGUAGE CXX)
target_include_directories(${STEP3_NOOSC_APP} PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${ROOT_INCLUDE_DIRS}
)
target_link_libraries(${STEP3_NOOSC_APP} PRIVATE ${ROOT_LIBRARIES})

if(OSCLIB_INCLUDE_DIR AND OSCLIB_LIBRARY)
  find_package(Eigen3 REQUIRED)
  find_library(GSL_LIBRARY NAMES gsl HINTS $ENV{GSL_LIB} $ENV{GSL_ROOT}/lib)
  find_library(GSL_CBLAS_LIBRARY NAMES gslcblas HINTS $ENV{GSL_LIB} $ENV{GSL_ROOT}/lib)
  if(NOT GSL_LIBRARY OR NOT GSL_CBLAS_LIBRARY)
    message(WARNING "GSL not found; OscLib-based step 3 apps may fail to link. Set GSL_LIB.")
  endif()
  add_library(ndgeoeff_calcs STATIC Calcs/Calcs.cxx)
  target_include_directories(ndgeoeff_calcs PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/Calcs
    ${OSCLIB_INCLUDE_DIR}
    ${ROOT_INCLUDE_DIRS}
  )
  set(OSCLIB_DEP_LIBS ${OSCLIB_LIBRARY} Eigen3::Eigen)
  if(GSL_LIBRARY AND GSL_CBLAS_LIBRARY)
    list(APPEND OSCLIB_DEP_LIBS ${GSL_LIBRARY} ${GSL_CBLAS_LIBRARY})
  endif()
  target_link_libraries(ndgeoeff_calcs PUBLIC ${OSCLIB_DEP_LIBS})

  set(STEP3_OSC_APPS
    NtupleOutVetoAndTrimE_AssumeEqualEffAtAllOA_WithOscSpectrumNOCAFAna_FDRateAtND
    NtupleOutVetoAndTrimE_AllOApos_WithOscSpectrumNOCAFAna_FDRateAtND
  )

  foreach(app ${STEP3_OSC_APPS})
    add_executable(${app} ${app}.C)
    set_source_files_properties(${app}.C PROPERTIES LANGUAGE CXX)
    target_include_directories(${app} PRIVATE
      ${CMAKE_CURRENT_SOURCE_DIR}
      ${OSCLIB_INCLUDE_DIR}
      ${ROOT_INCLUDE_DIRS}
    )
    target_link_libraries(${app} PRIVATE ndgeoeff_calcs ${ROOT_LIBRARIES} ${OSCLIB_LIBRARY})
  endforeach()
else()
  message(WARNING
    "OscLib headers or library not found. Building only the no-oscillation step 3 app. "
    "Set OSCLIB_INC and OSCLIB_LIB, or use apps/step3_etrim_analysis/Makefile.")
endif()
