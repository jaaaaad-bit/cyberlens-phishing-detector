@echo off
cd /d "%~dp0"

docker info >nul 2>&1
if errorlevel 1 (
    echo Docker is not running. Open Docker Desktop first.
    exit /b 1
)

if "%1"=="start"  goto start
if "%1"=="test"   goto test
if "%1"=="logs"   goto logs
if "%1"=="stop"   goto stop
if "%1"=="reset"  goto reset

echo Usage: cyberlens.bat [start ^| test ^| logs ^| stop ^| reset]
exit /b 0

:start
docker compose up --build -d
timeout /t 5 >nul
start http://localhost:8081
echo CyberLens is running at http://localhost:8081
exit /b 0

:test
for %%f in (1_safe 2_suspicious 3_dangerous) do (
    echo === %%f ===
    curl.exe -s -X POST http://localhost:8081/api/analyze/raw -H "Content-Type: text/plain" --data-binary @demo\samples\%%f.eml
    echo.
)
exit /b 0

:logs
docker compose logs -f backend
exit /b 0

:stop
docker compose down
exit /b 0

:reset
docker compose down -v
exit /b 0