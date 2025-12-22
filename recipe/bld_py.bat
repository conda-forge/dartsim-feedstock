:: Limit parallel jobs to 1 to reduce memory usage
set CMAKE_BUILD_PARALLEL_LEVEL=1

:: Avoid MSVC release flags that add /Zi and /GL (big memory spikes)
set "CMAKE_ARGS=%CMAKE_ARGS% -DDART_MSVC_DEFAULT_OPTIONS=ON"

:: Compiler flags to reduce memory usage:
:: - /Od         => disable optimizations
:: - /Zm1500     => increase compiler heap (change if needed)
:: - /bigobj     => allow larger .obj files
:: - (NO /Z7)    => no debug symbols
:: - (NO /GL)    => ensure LTCG is off
set CXXFLAGS=%CXXFLAGS% /Od /Zm1500 /bigobj

:: Install the Python package (triggers CMake build via pip)
python -m pip install . -vv
if errorlevel 1 exit 1
