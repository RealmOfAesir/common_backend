cmake_minimum_required(VERSION 3.5.0 FATAL_ERROR)
project(Test CXX)
set(CMAKE_CXX_EXTENSIONS OFF)

file(GLOB PROJECT_SOURCES ${PROJECT_SOURCE_DIR}/*.cpp ${PROJECT_SOURCE_DIR}/test_helpers/*.cpp)
file(GLOB EASYLOGGING_SOURCE ${CMAKE_SOURCE_DIR}/external/common/external/easyloggingpp/src/easylogging++.cc)
add_executable(Test ${PROJECT_SOURCES} ${EASYLOGGING_SOURCE} main.cpp)

add_test(NAME MyTest COMMAND Test)

include_directories("${CMAKE_SOURCE_DIR}/src")
include_directories("${CMAKE_SOURCE_DIR}/external/common/src")
include_directories("${CMAKE_SOURCE_DIR}/external/common/external/easyloggingpp/src")
include_directories("${CMAKE_SOURCE_DIR}/external/common/external/Catch/include")
include_directories("${CMAKE_SOURCE_DIR}/external/common/external/di/include")
include_directories("${CMAKE_SOURCE_DIR}/external/librdkafka/src-cpp")
include_directories("${CMAKE_SOURCE_DIR}/external/libpqxx/include")

find_library(LIBROA_COMMON_LIBRARY RealmOfAesirCommon HINTS ${CMAKE_SOURCE_DIR}/external/common/bin)
find_library(PQXX_LIBRARY pqxx HINTS ${CMAKE_SOURCE_DIR}/external/libpqxx/src/.libs)
find_library(LIBRDKAFKA_LIBRARY rdkafka HINTS ${CMAKE_SOURCE_DIR}/external/librdkafka/src)
find_library(LIBRDKAFKAPP_LIBRARY rdkafka++ HINTS ${CMAKE_SOURCE_DIR}/external/librdkafka/src-cpp)

if(NOT LIBROA_COMMON_LIBRARY)
    message(FATAL_ERROR "libroa not found")
endif()

if(NOT PQXX_LIBRARY)
    message(FATAL_ERROR "libpqxx not found")
endif()

if(NOT LIBRDKAFKA_LIBRARY)
    message(FATAL_ERROR "librdkafka not found")
endif()

if(NOT LIBRDKAFKAPP_LIBRARY)
    message(FATAL_ERROR "librdkafkapp not found")
endif()

target_link_libraries(Test PUBLIC ${LIBROA_COMMON_LIBRARY})
target_link_libraries(Test PUBLIC RealmOfAesirCommonBackend)
target_link_libraries(Test PUBLIC ${LIBRDKAFKAPP_LIBRARY})
target_link_libraries(Test PUBLIC ${LIBRDKAFKA_LIBRARY})
target_link_libraries(Test PUBLIC ${PQXX_LIBRARY})

find_package(PostgreSQL REQUIRED)
include_directories(${PostgreSQL_INCLUDE_DIRS})
target_link_libraries(Test PUBLIC ${PostgreSQL_LIBRARIES})

find_package( ZLIB REQUIRED )
include_directories( ${ZLIB_INCLUDE_DIRS} )
target_link_libraries(Test PUBLIC ${ZLIB_LIBRARIES} )

find_package (Threads)
target_link_libraries (Test PUBLIC ${CMAKE_THREAD_LIBS_INIT})

find_package(OpenSSL REQUIRED)
target_link_libraries (Test PUBLIC ${OPENSSL_LIBRARIES})