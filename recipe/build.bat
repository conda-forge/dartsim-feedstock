mkdir build && cd build

:: Check the number of cores use by ninja by default
ninja -h

cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DDART_MSVC_DEFAULT_OPTIONS=ON ^
    -DDART_VERBOSE=ON ^
    -DBUILD_TESTING:BOOL=ON ^
    -DASSIMP_AISCENE_CTOR_DTOR_DEFINED:BOOL=ON ^
    -DASSIMP_AIMATERIAL_CTOR_DTOR_DEFINED:BOOL=ON ^
    %SRC_DIR%

echo "Print CMakeOutput:"
type CMakeFiles\CMakeOutput.log
echo "Print CMakeOutput:"
type CMakeFiles\CMakeError.log
if errorlevel 1 exit 1

:: Use 3 core to try to avoid out of memory errors
:: See https://github.com/conda-forge/dartsim-feedstock/pull/27#issuecomment-1132570816 (where it was reduced to 4)
:: and https://github.com/conda-forge/dartsim-feedstock/pull/30#issuecomment-1149743621 (where it was reduced to 3)
ninja -j 3
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1

ctest --output-on-failure
if errorlevel 1 exit 1
