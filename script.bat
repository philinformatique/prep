@echo on
SET mypath=%~dp0

cls
if exist %windir%\PI\activation.txt (goto lenovoupdate)
if exist %windir%\PI\hostname.txt (goto diskmanagement)
echo Version 2020-10-19-2
echo.
echo Synchronisation de l'heure avec le serveur NTP...
net start w32time>nul
w32tm /resync>nul
echo.


echo.
wmic bios get serialnumber
echo.
set /p changehost=Changer le hostname (%ComputerName%)? (o/n)
if %changehost%==o goto :AskID
goto :diskmanagement
:AskID
Set "ID="
Set /P "ID=Nouveau nom: "
If Not Defined ID (Echo Ne peut pas etre vide
    GoTo AskID)
If /I "%ID%"=="%ComputerName%" Exit /B
If "%ID:~,1%"=="." (Echo Ne doit pas commencer pas un point
    GoTo AskID)

WMIC ComputerSystem Where Name="%ComputerName%" Call Rename "%ID%">%windir%\PI\hostname.txt

shutdown /r
echo Votre PC redemarrera pensez a mettre le HD seul en boot, Veuillez attendre...
pause>nul
pause>nul

REM Fin du nom de PC


:diskmanagement
echo Nom du PC : %ComputerName%
echo.
wmic bios get serialnumber>>%mypath:~0,-1%\%ComputerName%.txt

echo Procedons avec disk management, Appuyez sur une touche...
pause>nul
diskmgmt.msc
echo.

echo Procedons avec Activation windows, Appuyez sur une touche...
pause>nul
slmgr /ato
echo OK>%windir%\PI\activation.txt
echo.

echo Procedons avec la Protection du systeme, Appuyez sur une touche...
pause>nul
sysdm.cpl ,4
echo.

:lenovoupdate
if exist "C:\Program Files (x86)\Lenovo\System Update\tvsu.exe" (
echo Procedons avec Lenovo Update, Appuyez sur une touche...
pause>nul
"C:\Program Files (x86)\Lenovo\System Update\tvsu.exe"
echo.)



REM Windows Update
echo Procedons avec windows update, Appuyez sur une touche...
control.exe /name Microsoft.WindowsUpdate
echo.

echo Procedons avec la verification de la camera, Appuyez sur une touche...
pause>nul
start microsoft.windows.camera:
echo.

echo Procedons avec Gestionnaire de peripherique, Appuyez sur une touche...
pause>nul
devmgmt.msc
echo.

set /p watchguard=Installer WatchGuard VPN? (o/n)
REM Watchguard Installer
if %watchguard%==o (curl -o wg.exe https://cdn.watchguard.com/SoftwareCenter/Files/MUVPN_SSL/12_5_3/WG-MVPN-SSL_12_5_3.exe
%mypath:~0,-1%\wg.exe)
echo.

echo Pensez a coller le collant :)
pause>nul
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v script /f
rd /S /Q %windir%\PI
pause
