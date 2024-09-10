:: Check the number of cores to use by ninja by default
IF %CPU_COUNT% GTR 4 (
    set CMAKE_BUILD_PARALLEL_LEVEL=4
) ELSE (
    set CMAKE_BUILD_PARALLEL_LEVEL=%CPU_COUNT%
)

:: Install the Python package
python -m pip install . -vv
