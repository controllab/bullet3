@echo on

set cmake_version=3.14
set TOOLVERSION=msvc16
set PROJ_DIR_x86=vs2019
set PROJ_DIR_x64=vs2019-x64

IF EXIST "%xxsim_toolchain%\addToolchain32ToPath.bat" (
	CALL "%xxsim_toolchain%\addToolchain32ToPath.bat"
)

set "curdir=%~dp0"

setlocal
rem Search for VSWhere first
set "InstallerPath=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer"
if not exist "%InstallerPath%" set "InstallerPath=%ProgramFiles%\Microsoft Visual Studio\Installer"
if not exist "%InstallerPath%" goto :no-vswhere

set VSWHERE_ARGS=-latest -products * %VSWHERE_REQ% %VSWHERE_PRP% %VSWHERE_LMT%
set VSWHERE_REQ=-requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64
set VSWHERE_PRP=-property installationPath
set VSWHERE_LMT=-version "[16.0,17.0)"
set VSWHERE_ARGS=-latest -products * %VSWHERE_REQ% %VSWHERE_PRP% %VSWHERE_LMT%
set PATH=%PATH%;%InstallerPath%
for /f "usebackq tokens=*" %%i in (`vswhere %VSWHERE_ARGS%`) do (
	endlocal
	set "VCINSTALLDIR=%%i\VC\"
	set "VS150COMNTOOLS=%%i\Common7\Tools\"
)
endlocal
:no-vswhere:
	IF EXIST "%VS150COMNTOOLS%\VsDevCmd.bat" (
		set VSVARS32="%VS150COMNTOOLS%\VsDevCmd.bat"
		ECHO Found Visual C++ 2019
		set PROJ_DIR=VS2019
	) ELSE IF EXIST "%ProgramFiles%\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat" (
		set VSVARS32="%ProgramFiles%\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat"
		ECHO Found Visual C++ 2019
		set PROJ_DIR=VS2019
	) ELSE (
		echo No Visual C++ 2019 found
		pause
		exit
	)
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

mkdir install
cd install
mkdir include
robocopy ..\..\..\src include *.h /MIR

mkdir lib
robocopy ..\lib\Debug\ lib *.lib /MIR
robocopy ..\lib\Release\ lib *.lib /E
cd %curdir%

REM x64 build
REM __________

cd %PROJ_DIR_x64%

echo Building Bullet x64 Debug
echo _________________________
msbuild.exe "BULLET_PHYSICS.sln" /p:Configuration=Debug;Platform=x64 /t:Build /verbosity:minimal

echo Building Bullet x64 Release
echo ___________________________
msbuild.exe "BULLET_PHYSICS.sln" /p:Configuration=Release;Platform=x64 /t:Build /verbosity:minimal

mkdir install_x64
cd install_x64

mkdir include
robocopy ..\..\..\src include *.h /MIR

mkdir lib
robocopy ..\lib\Debug\ lib *.lib /MIR
robocopy ..\lib\Release\ lib *.lib /E

cd %curdir%

pause