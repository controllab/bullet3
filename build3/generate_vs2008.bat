@echo on

set cmake_version=3.0
set TOOLVERSION=msvc8

IF EXIST "%xxsim_toolchain%\addToolchain32ToPath.bat" (
	CALL "%xxsim_toolchain%\addToolchain32ToPath.bat"
)

set curdir = %CD%

mkdir vs2008 2> NUL

cd vs2008

cmake ..\..\ -G "Visual Studio 8 2005" -DUSE_DOUBLE_PRECISION=ON -DUSE_MSVC_FAST_FLOATINGPOINT=OFF -DCMAKE_INSTALL_PREFIX=%cd%\install

cd %curdir%
