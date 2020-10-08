@echo off

SET mypath=%~dp0

cls
echo Version 1.0
echo.
echo Synchronisation de l'heure avec le serveur NTP...
net start w32time>nul
w32tm /resync>nul
echo.

REM Hostname
echo.
echo Current hostname : %ComputerName%
echo.
wmic bios get serialnumber
echo.
set /p changehost=Changer le hostname? (O/N)
if %changehost%==o goto :AskID
goto update
:AskID
Set "ID="
Set /P "ID=Enter your new name: "
If Not Defined ID (Echo Can not be empty
    GoTo AskID)
If /I "%ID%"=="%ComputerName%" Exit /B
If "%ID:~,1%"=="." (Echo Must not begin with a period
    GoTo AskID)

WMIC ComputerSystem Where Name="%ComputerName%" Call Rename "%ID%"

:update 
wmic bios get serialnumber>>%mypath:~0,-1%\%ComputerName%.txt
REM Windows Update
set /p test1=Procedons avec windows update...
control.exe /name Microsoft.WindowsUpdate
echo.

set /p test1=Procedons avec disk management...
REM Disk Management
diskmgmt.msc
echo.

set /p test1=Procedons avec Activation windows...
REM Activation windows
slmgr /ato
echo.

set /p test1=Procedons avec Gestionnaire de peripherique...
REM Gestionnaire de peripherique
devmgmt.msc
echo.

set /p test1=Procedons avec Lenovo Update...
"C:\Program Files (x86)\Lenovo\System Update\tvsu.exe"
echo.

set /p test1=Procedons avec la Protection du systeme...
sysdm.cpl ,4
echo.

set /p test1=Procedons avec la verification de la camera...
start microsoft.windows.camera:
echo.

set /p watchguard=Installer WatchGuard VPN? 
if %watchguard%==o %mypath:~0,-1%\wg.exe
echo.

set /p test1=Pensez a coller le collant et mettre HD en boot seulement :)

:quit
