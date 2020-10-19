@echo off
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
set /p reboot=Votre PC redemarrera pensez a mettre le HD seul en boot, Veuillez attendre...
set /p reboot=Votre PC redemarrera pensez a mettre le HD seul en boot, Veuillez attendre...

REM Fin du nom de PC


:diskmanagement
echo Nom du PC : %ComputerName%
echo.
wmic bios get serialnumber>>%mypath:~0,-1%\%ComputerName%.txt

set /p test1=Procedons avec disk management, Appuyez sur une touche...
if not %test1%==n diskmgmt.msc
echo.

set /p test1=Procedons avec Activation windows, Appuyez sur une touche...
if not %test1%==n slmgr /ato
echo OK>%windir%\PI\activation.txt
echo.

set /p test1=Procedons avec la Protection du systeme, Appuyez sur une touche...
if not %test1%==n sysdm.cpl ,4
echo.

:lenovoupdate
if exist "C:\Program Files (x86)\Lenovo\System Update\tvsu.exe" (
set /p test1=Procedons avec Lenovo Update, Appuyez sur une touche...
if not %test1%==n "C:\Program Files (x86)\Lenovo\System Update\tvsu.exe"
echo.)



REM Windows Update
set /p test1=Procedons avec windows update, Appuyez sur une touche...
if not %test1%==n control.exe /name Microsoft.WindowsUpdate
echo.

set /p test1=Procedons avec la verification de la camera, Appuyez sur une touche...
if not %test1%==n start microsoft.windows.camera:
echo.

set /p test1=Procedons avec Gestionnaire de peripherique, Appuyez sur une touche...
REM Gestionnaire de peripherique
if not %test1%==n devmgmt.msc
echo.

set /p watchguard=Installer WatchGuard VPN? (o/n)
REM Watchguard Installer
if %watchguard%==o (curl -o wg.exe https://cdn.watchguard.com/SoftwareCenter/Files/MUVPN_SSL/12_5_3/WG-MVPN-SSL_12_5_3.exe
%mypath:~0,-1%\wg.exe)
echo.

set /p test1=Pensez a coller le collant :)
rd /S /Q %windir%\PI
echo Vous pouvez maintenant fermer cettre fenetre
