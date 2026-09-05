cmake_minimum_required(VERSION 3.22)
project(dartsim_consumer_smoke LANGUAGES C CXX)

find_package(DART REQUIRED COMPONENTS collision-bullet collision-ode CONFIG)

add_executable(dartsim_consumer_smoke main.cpp)
target_link_libraries(
  dartsim_consumer_smoke
  PRIVATE
    dart
    dart-collision-bullet
    dart-collision-ode)
target_compile_features(dartsim_consumer_smoke PRIVATE cxx_std_17)

enable_testing()
add_test(NAME dartsim_consumer_smoke COMMAND dartsim_consumer_smoke)
