#############################################################
#  Find mysqlclient                                         #
#  MYSQL_INCLUDE_DIR - where to find mysql.h, etc.          #
#  MYSQL_LIBRARIES   - List of libraries when using MySQL.  #
#  MYSQL_FOUND       - True if MySQL found.                 #
#############################################################
#
IF (MYSQL_BASEDIR)
  IF (NOT EXISTS ${MYSQL_BASEDIR})
    MESSAGE(FATAL_ERROR "* Directory ${MYSQL_BASEDIR} doesn't exist. Check the path for typos!")
  ENDIF(NOT EXISTS ${MYSQL_BASEDIR})
  MESSAGE(STATUS "* MYSQL_BASEDIR is set, looking for ${MYSQL_FORK} in ${MYSQL_BASEDIR}")
ENDIF()
# Also use MYSQL for MariaDB, as library names and all locations are the same
#
IF (MYSQL_FORK STREQUAL "MYSQL" OR MYSQL_FORK STREQUAL "MARIADB")
  SET(MYSQL_NAMES mysqlclient mysqlclient_r)
ENDIF()
#
IF(MYSQL_FORK STREQUAL "MYSQL")
  SET(PQUERY_EXT "ms")
  ADD_DEFINITIONS(-DMYSQL_FORK="MySQL")
  ADD_DEFINITIONS(-DMAXPACKET)
ENDIF()
#
IF(MYSQL_FORK STREQUAL "MARIADB")
  SET(PQUERY_EXT "md")
  ADD_DEFINITIONS(-DMYSQL_FORK="MariaDB")
ENDIF()
#
IF (MYSQL_FORK STREQUAL "PERCONASERVER")
  SET(MYSQL_NAMES perconaserverclient perconaserverclient_r)
  SET(PQUERY_EXT "ps")
  ADD_DEFINITIONS(-DMYSQL_FORK="Percona Server")
  ADD_DEFINITIONS(-DMAXPACKET)
ENDIF()
#
IF (MYSQL_FORK STREQUAL "PERCONACLUSTER")
  SET(MYSQL_NAMES perconaserverclient mysqlclient mysqlclient_r)
  SET(PQUERY_EXT "pxc")
  ADD_DEFINITIONS(-DMYSQL_FORK="Percona XtraDB Cluster")
ENDIF()
#
IF (MYSQL_FORK STREQUAL "WEBSCALESQL")
  SET(MYSQL_NAMES webscalesqlclient webscalesqlclient_r)
  SET(PQUERY_EXT "ws")
  ADD_DEFINITIONS(-DMYSQL_FORK="WebScaleSQL")
ENDIF()
#
IF (MYSQL_INCLUDE_DIR)
  # Already in cache, be silent
  SET(MYSQL_FIND_QUIETLY TRUE)
ENDIF (MYSQL_INCLUDE_DIR)
#
IF(STATIC_MYSQL)
  SET(_mysql_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
  SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
ENDIF(STATIC_MYSQL)
#
FIND_PATH(MYSQL_INCLUDE_DIR mysql.h
  ${BASEDIR}/include
  ${BASEDIR}/include/mysql
  /usr/local/include/mysql
  /usr/include/mysql
  /usr/local/mysql/include
  )
#
FIND_LIBRARY(MYSQL_LIBRARY
  NAMES ${MYSQL_NAMES}
  IF(MYSQL_BASEDIR)
    PATHS ${MYSQL_BASEDIR}/lib ${MYSQL_BASEDIR}/lib64
    NO_CMAKE_SYSTEM_PATH
  ELSE(MYSQL_BASEDIR)
    PATHS /usr/lib /usr/local/lib /usr/lib/x86_64-linux-gnu /usr/lib/i386-linux-gnu /usr/lib64 /usr/local/mysql/lib
  ENDIF(MYSQL_BASEDIR)
  PATH_SUFFIXES mysql
  )
#
IF (MYSQL_INCLUDE_DIR AND MYSQL_LIBRARY)
  SET(MYSQL_FOUND TRUE)
  SET(MYSQL_LIBRARIES ${MYSQL_LIBRARY} )
ELSE (MYSQL_INCLUDE_DIR AND MYSQL_LIBRARY)
  SET(MYSQL_FOUND FALSE)
  SET(MYSQL_LIBRARIES)
ENDIF (MYSQL_INCLUDE_DIR AND MYSQL_LIBRARY)
#
IF (MYSQL_FOUND)
  IF (NOT MYSQL_FIND_QUIETLY)
    MESSAGE(STATUS "Found ${MYSQL_FORK}: ${MYSQL_LIBRARY}")
#    MESSAGE(STATUS "Found ${MYSQL_FORK} include directory: ${MYSQL_INCLUDE_DIR}")
  ENDIF (NOT MYSQL_FIND_QUIETLY)
ELSE (MYSQL_FOUND)
  MESSAGE(STATUS "Looked for ${MYSQL_FORK} libraries named ${MYSQL_NAMES}.")
  MESSAGE(FATAL_ERROR "Could NOT find ${MYSQL_FORK} library")
ENDIF (MYSQL_FOUND)
#
MARK_AS_ADVANCED(MYSQL_LIBRARY MYSQL_INCLUDE_DIR)
#
IF(STATIC_MYSQL)
  SET(CMAKE_FIND_LIBRARY_SUFFIXES ${_mysql_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
ENDIF()
#
