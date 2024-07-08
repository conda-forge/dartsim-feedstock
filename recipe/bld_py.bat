:: Check the number of cores to use by ninja by default
IF %CPU_COUNT% GTR 8 (
    set CMAKE_BUILD_PARALLEL_LEVEL=8
) ELSE (
    set CMAKE_BUILD_PARALLEL_LEVEL=%CPU_COUNT%
)

:: Install the Python package
python -m pip install .
