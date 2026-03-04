@echo off
setlocal
cd /d "%~dp0"
set "PYTHONPATH=%CD%\src"

if /I not "%~1"=="--launched" (
    if defined WT_SESSION (
        start "Project Fantasy Ver 1" "%SystemRoot%\System32\conhost.exe" "%SystemRoot%\System32\cmd.exe" /D /Q /C ""%~f0" --launched"
        exit /b
    )
)

if exist ".venv\Scripts\python.exe" (
    ".venv\Scripts\python.exe" -m rpg
) else (
    python -m rpg
)

exit /b %errorlevel%
