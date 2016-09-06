IF (GIT_FOUND)
  EXECUTE_PROCESS(COMMAND "${GIT_EXECUTABLE}" rev-parse --short HEAD
  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
  RESULT_VARIABLE res OUTPUT_VARIABLE REVISION
  OUTPUT_STRIP_TRAILING_WHITESPACE)
  IF(NOT res EQUAL 0)
    SET(REVISION "NOTFOUND")
  ENDIF()
ELSEIF()
  SET(REVISION "NOTFOUND")
ENDIF()
#
MESSAGE(STATUS "* PQuery revision is: " ${REVISION})
ADD_DEFINITIONS(-DPQREVISION="${REVISION}")
