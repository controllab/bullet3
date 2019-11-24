@echo on

set cmake_version=3.7
set TOOLVERSION=msvc15
set PROJ_DIR_x86=vs2017
set PROJ_DIR_x64=vs2017-x64


IF EXIST "%xxsim_toolchain%\addToolchain32ToPath.bat" (
	CALL "%xxsim_toolchain%\addToolchain32ToPath.bat"
)

set curdir=%~dp0

mkdir %PROJ_DIR_x86% 2> NUL
cd %PROJ_DIR_x86%
cmake ..\..\ -G "Visual Studio 15 2017" -DUSE_DOUBLE_PRECISION=ON -DUSE_MSVC_FAST_FLOATINGPOINT=OFF -DUSE_MSVC_SSE2=ON -DCMAKE_INSTALL_PREFIX=%cd%\install
cd %curdir%

mkdir %PROJ_DIR_x64% 2> NUL
cd %PROJ_DIR_x64%
cmake ..\..\ -G "Visual Studio 15 2017 Win64" -DUSE_DOUBLE_PRECISION=ON -DUSE_MSVC_FAST_FLOATINGPOINT=OFF -DCMAKE_INSTALL_PREFIX=%cd%\install
cd %curdir%
