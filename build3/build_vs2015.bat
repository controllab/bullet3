@echo on

set cmake_version=3.3
set TOOLVERSION=msvc14
set PROJ_DIR_x86=vs2015
set PROJ_DIR_x64=vs2015-x64

IF EXIST "%xxsim_toolchain%\addToolchain32ToPath.bat" (
	CALL "%xxsim_toolchain%\addToolchain32ToPath.bat"
)

set curdir = %CD%

IF EXIST "%VS140COMNTOOLS%\vsvars32.bat" (
	set VSVARS32="%VS140COMNTOOLS%\vsvars32.bat"
	ECHO Found Visual C++ 2015
) ELSE IF EXIST "%ProgramFiles%\Microsoft Visual Studio 14.0\Common7\Tools\vsvars32.bat" (
	set VSVARS32="%VS140COMNTOOLS%\vsvars32.bat"
	ECHO Found Visual C++ 2015
)

IF DEFINED VSVARS32 (
	echo Loading vsvar32
	call %VSVARS32%
)

REM x64 build
REM __________
cd %PROJ_DIR_x86%

echo Building Bullet x86 Debug
echo _________________________
msbuild.exe "BULLET_PHYSICS.sln" /p:Configuration=Debug;Platform=win32 /t:Build /verbosity:minimal

echo Building Bullet x86 Release
echo ___________________________
msbuild.exe "BULLET_PHYSICS.sln" /p:Configuration=Release;Platform=win32 /t:Build /verbosity:minimal

cd %curdir%

mkdir install
cd install

mkdir lib
mkdir include

robocopy ..\%PROJ_DIR_x86%\lib\Debug\ lib *.lib /MIR
robocopy ..\%PROJ_DIR_x86%\lib\Release\ lib *.lib /E
robocopy ..\..\src include *.h /MIR

REM x64 build
REM __________
cd %PROJ_DIR_x64%

echo Building Bullet x64 Debug
echo _________________________
msbuild.exe "BULLET_PHYSICS.sln" /p:Configuration=Debug;Platform=x64 /t:Build /verbosity:minimal

echo Building Bullet x64 Release
echo ___________________________
msbuild.exe "BULLET_PHYSICS.sln" /p:Configuration=Release;Platform=x64 /t:Build /verbosity:minimal

cd %curdir%

mkdir install_x64
cd install_x64

mkdir lib
mkdir include

robocopy ..\%PROJ_DIR_x64%\lib\Debug\ lib *.lib /MIR
robocopy ..\%PROJ_DIR_x64%\lib\Debug\ lib *.lib /E
robocopy ..\..\src include *.h /MIR

cd %curdir%

pause