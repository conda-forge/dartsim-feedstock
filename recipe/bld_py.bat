:: Keep some parallelism to reduce wall time while avoiding OOM
set CMAKE_BUILD_PARALLEL_LEVEL=2

:: Remove C++ build artifacts from previous output to free disk space
if exist build rmdir /s /q build

:: Use a build temp directory on the system drive to avoid D: disk exhaustion
set "DARTPY_BUILD_TEMP=%USERPROFILE%\\AppData\\Local\\Temp\\dartpy_build"

:: Avoid MSVC release flags that add /Zi and /GL (big memory spikes)
set "CMAKE_ARGS=%CMAKE_ARGS% -DDART_MSVC_DEFAULT_OPTIONS=ON"

:: Compiler flags to reduce memory usage:
:: - /Od         => disable optimizations
:: - /Zm2000     => increase compiler heap (change if needed)
:: - /bigobj     => allow larger .obj files
:: - (NO /Z7)    => no debug symbols
:: - (NO /GL)    => ensure LTCG is off
set "CL=%CL% /Od /Zm2000 /bigobj"
set CXXFLAGS=%CXXFLAGS% /Od /Zm2000 /bigobj

:: Install the Python package (triggers CMake build via pip)
python -m pip install . -vv
if errorlevel 1 exit 1
