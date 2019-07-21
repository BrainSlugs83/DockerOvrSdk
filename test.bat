@echo off
SET PROJ=%~1
IF "%PROJ%"=="" SET PROJ=D:\projects.git\ovr\VrSamples\VrController

del %proj%\*.apk >nul 2>&1
docker run -it --rm -v %PROJ%:/proj brainslugs83/ovrsdk /opt/build.sh

dir %proj%\*.apk /b
