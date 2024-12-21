:: Limit parallel jobs to 1 to reduce memory usage
set CMAKE_BUILD_PARALLEL_LEVEL=1

:: Add compiler flags:
::   /Zm1600  increases compiler memory limit
::   /bigobj  allows larger object files
::   /Zc:inline  controls inline function expansion
set CXXFLAGS=%CXXFLAGS% /Zm1500 /bigobj /Zc:inline /Z7 /O1

:: Install the Python package (which will invoke CMake under the hood)
python -m pip install . -vv
if errorlevel 1 exit 1
