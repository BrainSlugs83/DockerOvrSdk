@echo off
if exist ".\src\ovr_sdk_mobile_1.23.zip" goto BUILD

echo.
echo FILE NOT FOUND: ".\src\ovr_sdk_mobile_1.23.zip"!
echo.
echo Make sure to download this file via: https://developer.oculus.com/downloads/package/oculus-mobile-sdk/
echo.
echo and to place it inside the ".\src\" folder!
echo.

exit /b 100

:BUILD

echo good!
exit /b 0

call clean.bat
docker build -t brainslugs83/ovrsdk:latest .
docker images
