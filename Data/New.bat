@echo off
title SpeedWave - by Sou Studio
chcp 65001 >nul
color 0A

:: Logging setup
set "LogFile=%temp%\SpeedWaveLog.txt"
echo [%date% %time%] Script started. >> %LogFile%

:: Function to fetch version and content
:FetchData
setlocal enabledelayedexpansion
set "VersionURL=https://nittarpp.github.io/SpeedWave/Data/"
set "TempFile=%temp%\current_version.txt"
set "ErrorVersion="
:: Timeout for curl and retries in case of failure
for /L %%n in (1,1,3) do (
    curl -s --max-time 10 %VersionURL% > "%TempFile%" 2>> "%LogFile%"
    if !ERRORLEVEL! EQU 0 (
        call :ProcessVersion
        exit /b
    )
    echo [%date% %time%] Attempt %%n to fetch version info failed. >> %LogFile%
    timeout /t 5 /nobreak >nul
)
echo [%date% %time%] Failed to fetch version info after 3 attempts. >> %LogFile%
echo Failed to fetch version info.
echo Press any key to continue without updating the version.
set "ErrorVersion=true"
call :starter
exit /b

:ProcessVersion
set Ver="1.0.1"
:: Extract new version from downloaded file
set "Newver="
for /f "delims=" %%i in (%TempFile%) do set "Newver=%%i"
if "%Newver%"=="" (
    echo [%date% %time%] Failed to read version info from %TempFile%. >> %LogFile%
    echo Press any key to continue without updating the version.
    set "ErrorVersion=true"
    call :menu
)
:: Convert versions to numbers for comparison
for /f "tokens=1,2,3 delims=." %%a in ("%Ver%") do (
    set /a Ver1=%%a
    set /a Ver2=%%b
    set /a Ver3=%%c
)
for /f "tokens=1,2,3 delims=." %%a in ("%Newver%") do (
    set /a Newver1=%%a
    set /a Newver2=%%b
    set /a Newver3=%%c
)
:: Compare versions
set "VersionUpdateNeeded=false"
if !Ver1! LSS !Newver1! (
    set "VersionUpdateNeeded=true"
) else if !Ver1! EQU !Newver1! (
    if !Ver2! LSS !Newver2! (
        set "VersionUpdateNeeded=true"
    ) else if !Ver2! EQU !Newver2! (
        if !Ver3! LSS !Newver3! (
            set "VersionUpdateNeeded=true"
        )
    )
)

:: Log version comparison result
echo [%date% %time%] Current version: %Ver%, New version: %Newver%. Update needed: %VersionUpdateNeeded% >> %LogFile%

:: Fetch update content and code
set "OF_URL=https://nittarpp.github.io/SpeedWave/Data/update.html"
set "TempFile=%temp%\of.txt"
curl -s --max-time 10 %OF_URL% > "%TempFile%" 2>> "%LogFile%"

if !ERRORLEVEL! NEQ 0 (
    echo [%date% %time%] Failed to fetch content. >> %LogFile%
    echo Failed to fetch content.
    pause
    exit /b
)

set "Code_Url=https://nittarpp.github.io/SpeedWave/Data/code.html"
set "CodeFile=%temp%\code.txt"
curl -s --max-time 10 %Code_Url% > "%CodeFile%" 2>> "%LogFile%"

if !ERRORLEVEL! NEQ 0 (
    echo [%date% %time%] Failed to fetch code. >> %LogFile%
    echo Failed to fetch code.
    pause
    exit /b
)

:: Read the content
set "Content="
for /f "delims=" %%i in (%TempFile%) do set "Content=%%i"
echo [%date% %time%] Content from %TempFile%: %Content% >> %LogFile%

:: Determine action based on fetched content
if "%Content%"=="Normal" (
    call :starter
) else if "%Content%"=="Event" (
    call :Event
) else if "%Content%"=="Temporarily disabled" (
    call :Temporarily
) else if "%Content%"=="Error" (
    echo [%date% %time%] Error in fetching web data. >> %LogFile%
    exit /b
) else (
    echo [%date% %time%] Unknown response from web: %Content%. >> %LogFile%
    pause
    exit /b
)
goto :starter

:Event
cls
echo.
echo           ███████╗██████╗ ███████╗███████╗██████╗     ██╗    ██╗ █████╗ ██╗   ██╗███████╗
echo           ██╔════╝██╔══██╗██╔════╝██╔════╝██╔══██╗    ██║    ██║██╔══██╗██║   ██║██╔════╝
echo           ███████╗██████╔╝█████╗  █████╗  ██║  ██║    ██║ █╗ ██║███████║██║   ██║█████╗  
echo           ╚════██║██╔═══╝ ██╔══╝  ██╔══╝  ██║  ██║    ██║███╗██║██╔══██║╚██╗ ██╔╝██╔══╝  
echo           ███████║██║     ███████╗███████╗██████╔╝    ╚███╔███╔╝██║  ██║ ╚████╔╝ ███████╗
echo           ╚══════╝╚═╝     ╚══════╝╚══════╝╚═════╝      ╚══╝╚══╝ ╚═╝  ╚═╝  ╚═══╝  ╚══════╝
echo.
echo                                                   Event
echo.
goto Event

:Temporarily
cls
echo.
echo           ███████╗██████╗ ███████╗███████╗██████╗     ██╗    ██╗ █████╗ ██╗   ██╗███████╗
echo           ██╔════╝██╔══██╗██╔════╝██╔════╝██╔══██╗    ██║    ██║██╔══██╗██║   ██║██╔════╝
echo           ███████╗██████╔╝█████╗  █████╗  ██║  ██║    ██║ █╗ ██║███████║██║   ██║█████╗  
echo           ╚════██║██╔═══╝ ██╔══╝  ██╔══╝  ██║  ██║    ██║███╗██║██╔══██║╚██╗ ██╔╝██╔══╝  
echo           ███████║██║     ███████╗███████╗██████╔╝    ╚███╔███╔╝██║  ██║ ╚████╔╝ ███████╗
echo           ╚══════╝╚═╝     ╚══════╝╚══════╝╚═════╝      ╚══╝╚══╝ ╚═╝  ╚═╝  ╚═══╝  ╚══════╝
echo.
echo                                               Temporarily
echo.
goto Temporarily

:starter
cls
call :banner
:menu
echo.
if "%VersionUpdateNeeded%"=="true" (
    
    echo New version available: %Newver%. Use 'Update' to get the new version.
    set "UpdateURL=https://nittarpp.github.io/SpeedWave/Data/New.bat"
set "UpdateFile=SpeedWaveUpdate.bat"
set "LogFile=UpdateLog.txt"

:AutoUpdate
curl -s --max-time 10 %UpdateURL% > "%UpdateFile%" 2>> "%LogFile%"

if %ERRORLEVEL% neq 0 (
    echo [%date% %time%] Failed to download the new version. >> %LogFile%
    echo Failed to fetch the new version.
    pause
    exit /b
)

echo [%date% %time%] Update downloaded successfully. >> %LogFile%
echo Update downloaded successfully.

) else if "%ErrorVersion%"=="true" (
    echo Failed to load version and new version.
) else (
    echo You have the latest version %Ver%.
)
echo.
echo         ╔═ (1) Clear temporary files
echo         ╠═ (2) Run disk cleanup
echo         ╠═ (3) Optimize startup programs
echo         ╠═ (4) Check for system updates
echo         ╠═══ (5) Exit
echo.
set /p input=Enter your choice :
if "%input%"=="1" (
    cls
    call :CTF
) else if "%input%"=="2" (
    cls
    cleanmgr /sagerun:1
    goto :menu
) else if "%input%"=="3" (
    cls
    call :FetchData
) else if "%input%"=="4" (
    cls
    call :FetchData
) else if "%input%"=="5" (
    exit
) else (
    goto :menu
)

:CTF
echo Deleting temporary files... Progress: 50%
del /f /s /q %temp%\* > nul
echo Temporary files deleted.
timeout /t 2 > nul
goto :menu

:banner
cls
echo.
echo           ███████╗██████╗ ███████╗███████╗██████╗     ██╗    ██╗ █████╗ ██╗   ██╗███████╗
echo           ██╔════╝██╔══██╗██╔════╝██╔════╝██╔══██╗    ██║    ██║██╔══██╗██║   ██║██╔════╝
echo           ███████╗██████╔╝█████╗  █████╗  ██║  ██║    ██║ █╗ ██║███████║██║   ██║█████╗  
echo           ╚════██║██╔═══╝ ██╔══╝  ██╔══╝  ██║  ██║    ██║███╗██║██╔══██║╚██╗ ██╔╝██╔══╝  
echo           ███████║██║     ███████╗███████╗██████╔╝    ╚███╔███╔╝██║  ██║ ╚████╔╝ ███████╗
echo           ╚══════╝╚═╝     ╚══════╝╚══════╝╚═════╝      ╚══╝╚══╝ ╚═╝  ╚═╝  ╚═══╝  ╚══════╝
echo.
