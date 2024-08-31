@echo off

setlocal enabledelayedexpansion
set "VersionURL=https://nittarpp.github.io/Sou-Update/"
set "TempFile=%temp%\current_version.txt" 

for /f "tokens=1,2,3 delims=." %%a in ("%Newver%") do (
    set /a Newver1=%%a
    set /a Newver2=%%b
    set /a Newver3=%%c
)

echo	                   Update Logs For 0.0.3 (Demo)
echo.
echo                              Add Update Logs
echo                     Update Sou Studio For More Speed
echo                            Add Best Power Plan
echo.
echo.
echo                                 Get Now
pause
start https://github.com/NittarPP/Sou-Update/releases/download/Update/Sou.Studio.bat
del Sou.Studio.bat
