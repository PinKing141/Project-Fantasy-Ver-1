@echo off
setlocal
cd /d "%~dp0"

set "EXITCODE=0"
set "EXE_NAME=ProjectFantasyVer1"
set "RELEASE_DIR=release\windows\%EXE_NAME%"

set "PY=.venv\Scripts\python.exe"
if not exist "%PY%" set "PY=python"

if exist "dist\data" rmdir /s /q "dist\data"

echo Building console executable with PyInstaller...
"%PY%" -m PyInstaller --noconfirm --clean --onefile --name "%EXE_NAME%" --paths "src" --add-data "data;data" src\rpg\__main__.py
if errorlevel 1 (
    echo.
    echo Build failed.
    set "EXITCODE=1"
    goto :done
)

if exist "data" (
    echo Copying runtime data into dist\data...
    xcopy "data" "dist\data\" /E /I /Y >nul
)

taskkill /IM %EXE_NAME%.exe /F >nul 2>&1

if exist "%RELEASE_DIR%" (
    rmdir /s /q "%RELEASE_DIR%"
    if exist "%RELEASE_DIR%" (
        echo.
        echo Failed to clear existing release folder: %RELEASE_DIR%
        echo Close any running game instances and try again.
        set "EXITCODE=1"
        goto :done
    )
)

mkdir "%RELEASE_DIR%"
copy /Y "dist\%EXE_NAME%.exe" "%RELEASE_DIR%\%EXE_NAME%.exe" >nul
if errorlevel 1 (
    echo.
    echo Failed to copy executable into release folder.
    set "EXITCODE=1"
    goto :done
)

if exist "dist\data" (
    xcopy "dist\data" "%RELEASE_DIR%\data\" /E /I /Y >nul
    if errorlevel 2 (
        echo.
        echo Failed to copy runtime data into release folder.
        set "EXITCODE=1"
        goto :done
    )
)

echo.
echo Build complete.
echo Executable: dist\%EXE_NAME%.exe
echo Runtime data: dist\data
echo Release output: %RELEASE_DIR%\%EXE_NAME%.exe

:done
echo.
set /p "_INPUT=Press ENTER to close..."
exit /b %EXITCODE%
