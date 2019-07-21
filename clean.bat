@echo off
docker rmi brainslugs83/ovrsdk:latest -f >nul 2>&1
docker system prune --volumes -f  >nul 2>&1