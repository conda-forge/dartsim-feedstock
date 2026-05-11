cmake_minimum_required(VERSION 3.22)
project(dartsim_consumer_smoke LANGUAGES CXX)

find_package(DART 6.16 REQUIRED CONFIG)

add_executable(dartsim_consumer_smoke main.cpp)
target_link_libraries(dartsim_consumer_smoke PRIVATE dart)
target_compile_features(dartsim_consumer_smoke PRIVATE cxx_std_17)
