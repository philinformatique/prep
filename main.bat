@echo off
cls
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
if exist %windir%\PI (goto menu1) 
Echo 1. Script apres images
Echo q pour Quitter
set /p menumain=Votre choix? :

if %menumain%==1 goto :menu1
if %menumain%==q goto :end

:menu1
curl -o %windir%\PI\script2.bat https://raw.githubusercontent.com/philinformatique/prep/main/script.bat
%windir%\PI\script2.bat

:end
