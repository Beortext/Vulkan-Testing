#----------------------------------------------------------------
# Generated CMake target import file for configuration "RelWithDebInfo".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "spirv-cross-c-shared" for configuration "RelWithDebInfo"
set_property(TARGET spirv-cross-c-shared APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(spirv-cross-c-shared PROPERTIES
  IMPORTED_LOCATION_RELWITHDEBINFO "${_IMPORT_PREFIX}/lib/libspirv-cross-c-shared.0.61.0.dylib"
  IMPORTED_SONAME_RELWITHDEBINFO "@rpath/libspirv-cross-c-shared.0.dylib"
  )

list(APPEND _cmake_import_check_targets spirv-cross-c-shared )
list(APPEND _cmake_import_check_files_for_spirv-cross-c-shared "${_IMPORT_PREFIX}/lib/libspirv-cross-c-shared.0.61.0.dylib" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)