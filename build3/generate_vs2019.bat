@echo on

set cmake_version=3.14
set TOOLVERSION=msvc16
set PROJ_DIR_x86=vs2019
set PROJ_DIR_x64=vs2019-x64


IF EXIST "%xxsim_toolchain%\addToolchain32ToPath.bat" (
	CALL "%xxsim_toolchain%\addToolchain32ToPath.bat"
)

set curdir=%~dp0

mkdir %PROJ_DIR_x86% 2> NUL
cd %PROJ_DIR_x86%
cmake ..\..\ -G "Visual Studio 16 2019" -A Win32 -DUSE_DOUBLE_PRECISION=ON -DUSE_MSVC_FAST_FLOATINGPOINT=OFF -DCMAKE_INSTALL_PREFIX=%cd%\install
cd %curdir%

mkdir %PROJ_DIR_x64% 2> NUL
cd %PROJ_DIR_x64%
cmake ..\..\ -G "Visual Studio 16 2019" -A x64 -DUSE_DOUBLE_PRECISION=ON -DUSE_MSVC_FAST_FLOATINGPOINT=OFF -DUSE_MSVC_SSE2=ON -DCMAKE_INSTALL_PREFIX=%cd%\install
cd %curdir%
