@echo off
setlocal
title AutoMount Viewer/Disabler/Enabler
echo Program Name: AutoMount Viewer/Disabler/Enabler
echo Version: 2.0.3
echo License: GNU General Public License v3.0
echo Developer: @YonatanReuvenIsraeli
echo GitHub: https://github.com/YonatanReuvenIsraeli
echo Sponsor: https://github.com/sponsors/YonatanReuvenIsraeli
"%windir%\System32\net.exe" session > nul 2>&1
if not "%errorlevel%"=="0" goto "NotAdministrator"
goto "Start"

:"NotAdministrator"
echo.
echo Please run this batch file as an administrator. Press any key to close this batch file.
pause > nul 2>&1
goto "Close"

:"Start"
echo.
echo [1] View current auto-mount status.
echo [2] Disable auto-mounting of new drives.
echo [3] Enable auto-mounting of new drives. (Windows Default)
echo [4] Exit.
echo.
set AutoMount=
set /p AutoMount="What do you want to do? "
if /i "%AutoMount%"=="1" goto "DiskPartSet"
if /i "%AutoMount%"=="2" goto "DiskPartSet"
if /i "%AutoMount%"=="3" goto "DiskPartSet"
if /i "%AutoMount%"=="4" goto "Close"
echo Invalid syntax!
goto "Start"

:"DiskPartSet"
set DiskPart=
if /i "%AutoMount%"=="1" goto "1"
if /i "%AutoMount%"=="2" goto "2"
if /i "%AutoMount%"=="3" goto "3"

:"1"
if exist "diskpart.txt" goto "DiskPartExist"
(echo automount) > "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt"
if not "%errorlevel%"=="0" goto "DiskPartError"
del "diskpart.txt" /f /q > nul 2>&1
if /i "%DiskPart%"=="True" goto "DiskPartDone"
goto "Start"

:"2"
if exist "diskpart.txt" goto "DiskPartExist"
(echo automount disable) > "diskpart.txt"
(echo automount scrub) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt"
if not "%errorlevel%"=="0" goto "DiskPartError"
del "diskpart.txt" /f /q > nul 2>&1
if /i "%DiskPart%"=="True" goto "DiskPartDone"
goto "Start"

:"3"
if exist "diskpart.txt" goto "DiskPartExist"
(echo automount enable) > "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt"
if not "%errorlevel%"=="0" goto "DiskPartError"
del "diskpart.txt" /f /q > nul 2>&1
if /i "%DiskPart%"=="True" goto "DiskPartDone"
goto "Start"

:"DiskPartExist"
set DiskPart=True
echo.
echo Please temporary rename to something else or temporary move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
if /i "%AutoMount%"=="1" goto "1"
if /i "%AutoMount%"=="2" goto "2"
if /i "%AutoMount%"=="3" goto "3"

:"DiskPartError"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
if /i "%AutoMount%"=="1" goto "1"
if /i "%AutoMount%"=="2" goto "2"
if /i "%AutoMount%"=="3" goto "3"

:"DiskPartDone"
echo.
echo You can now rename or move back the file back to "diskpart.txt".
goto "Start"

:"Close"
endlocal
exit
