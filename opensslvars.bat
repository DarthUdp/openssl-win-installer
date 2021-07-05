@echo off

rem Ensure the openssl install is in the path
set "PATH=%~dp0bin;%PATH%"

setlocal enabledelayedexpansion
pushd "%~dp0"

rem Figure out the Node.js version.
set print_version=.\bin\openssl.exe version
for /F "usebackq delims=" %%v in (`%print_version%`) do set version=%%v

rem Print message.
echo Your environment has been set up for using openssl !version!.

popd
endlocal

rem go to the user's home directory.
if "%CD%\"=="%~dp0" cd /d "%HOMEDRIVE%%HOMEPATH%"