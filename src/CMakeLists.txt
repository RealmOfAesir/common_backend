cmake_minimum_required(VERSION 3.5.0 FATAL_ERROR)
project(RealmOfAesirCommonBackend CXX)

file(GLOB_RECURSE REPOS_SRCS ${PROJECT_SOURCE_DIR}/repositories/*.cpp)
file(GLOB PROJECT_SOURCES ${PROJECT_SOURCE_DIR}/*.cpp ${REPOS_SRCS})
add_library(RealmOfAesirCommonBackend ${PROJECT_SOURCES})

include_directories("${PROJECT_SOURCE_DIR}")

include_directories("${CMAKE_SOURCE_DIR}/external/common/src")
include_directories("${CMAKE_SOURCE_DIR}/external/common/external/easyloggingpp/src")
include_directories("${CMAKE_SOURCE_DIR}/external/libpqxx/include")
include_directories("${CMAKE_SOURCE_DIR}/external/librdkafka/src-cpp")

find_library(LIBROA_COMMON_LIBRARY RealmOfAesirCommon HINTS ${CMAKE_SOURCE_DIR}/external/common/bin)
find_library(PQXX_LIBRARY pqxx HINTS ${CMAKE_SOURCE_DIR}/external/libpqxx/src/.libs)

if(NOT LIBROA_COMMON_LIBRARY)
    message(FATAL_ERROR "libroa not found")
endif()

if(NOT PQXX_LIBRARY)
    message(FATAL_ERROR "libpqxx not found")
endif()

target_link_libraries(RealmOfAesirCommonBackend PUBLIC ${LIBROA_COMMON_LIBRARY})
target_link_libraries(RealmOfAesirCommonBackend PUBLIC ${PQXX_LIBRARY})

find_package(PostgreSQL REQUIRED)
include_directories(${PostgreSQL_INCLUDE_DIRS})
target_link_libraries(RealmOfAesirCommonBackend PUBLIC ${PostgreSQL_LIBRARIES})

target_link_libraries(RealmOfAesirCommonBackend PUBLIC ${CMAKE_SOURCE_DIR}/external/librdkafka/src/librdkafka.a)
target_link_libraries(RealmOfAesirCommonBackend PUBLIC ${CMAKE_SOURCE_DIR}/external/librdkafka/src-cpp/librdkafka++.a)

find_package( ZLIB REQUIRED )
include_directories( ${ZLIB_INCLUDE_DIRS} )
target_link_libraries(RealmOfAesirCommonBackend PUBLIC ${ZLIB_LIBRARIES} )

find_package (Threads)
target_link_libraries (RealmOfAesirCommonBackend PUBLIC ${CMAKE_THREAD_LIBS_INIT})

find_package(OpenSSL REQUIRED)
target_link_libraries (RealmOfAesirCommonBackend PUBLIC ${OPENSSL_LIBRARIES})