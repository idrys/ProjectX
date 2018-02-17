echo 1. Wysy�anie emaila z TV
echo 2. Auto nacisniecie entera po wprowadzeniu klucza domyslnego
echo 3. Uruchomienie po instalcji systemu

set /p desktopnr="Podaj nr koputera (nalepka na obudowie z napisem Desktop???) tylko nr : 

for /f "delims=" %%i in ("%0") do set "cd=%%~dpi"
echo %cd%

@echo off
echo Okreslenie bierzacej scierzki

@echo
echo Okreslenie architektury systemu
echo PROCESSOR_ARCHITECTURE reg:
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE | find /i "x86" > nul
if %errorlevel%==0 (
 SET ARCHITECTURE="32-bit"
) else (
  SET ARCHITECTURE="64-bit")
echo.

ECHO %ARCHITECTURE%

echo Instalacja TeamViewer 10
reg import %cd%TeamViewerSettings1.reg
%cd%\TeamViewer_Setup.exe /S
reg import %cd%TeamViewerSettings1.reg

echo libre office 5.2.2
start /wait %cd%\LibreOffice_5.2.2_Win_x86.msi /passive

echo google chrome
start /wait %cd%\GoogleChromeStandaloneEnterprise.msi /passive

echo adobe reader 11
start /wait %cd%\AdbeRdr11000_pl_PL.exe /sAll /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES

echo 7zip 9.20
start /wait %cd%\7z920.msi /passive

echo ustawienia uzytkownikow

net user User /logonpasswordchg:no
wmic useraccount where Name="User" SET PasswordExpires=false
net user Admin /logonpasswordchg:no
wmic useraccount where Name="Admin" SET PasswordExpires=false

wmic computersystem where name="%computername%" call rename name='Desktop%desktopnr%'
wmic computersystem where name="%computername%" call joindomainorworkgroup name="SPRZEDAZ"

copy %cd%\Fiskalna\*.* c:\Windows\System32\

set firstUserRun="c:\Users\Public\FirstUserRun\"
cd c:\Users\Public
mkdir FirstUserRun


copy %cd%\install2.cmd %firstUserRun%
copy %cd%\SchedulerTask.xml %firstUserRun%
copy %cd%\rdpcli98_1.reg %firstUserRun%
copy %cd%\rdpcli98_2.reg %firstUserRun%


schtasks /create /tn FirstUserRun /xml c:\Users\Public\FirstUserRun\SchedulerTask.xml 
slmgr.vbs /ipk VK7JG-NPHTM-C97JM-9MPGT-3V66T

echo reg import %cd%\autologin.reg


echo echo eset endpoint 6.4
IF %ARCHITECTURE%=="32-bit" (start /wait %cd%\ees_nt32_plk.msi /passive) else ( start /wait %cd%\ees_nt32_plk.msi /passive )

echo eset EraAgent
%cd%\EraAgentInstaller.bat
