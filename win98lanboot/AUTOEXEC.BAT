@ECHO OFF
set EXPAND=YES
SET DIRCMD=/O:N
set LglDrv=27 * 26 Z 25 Y 24 X 23 W 22 V 21 U 20 T 19 S 18 R 17 Q 16 P 15
set LglDrv=%LglDrv% O 14 N 13 M 12 L 11 K 10 J 9 I 8 H 7 G 6 F 5 E 4 D 3 C
cls
call setramd.bat %LglDrv%
set temp=c:\
set tmp=c:\

copy command.com %RAMD%:\ > NUL
set comspec=%RAMD%:\command.com
copy extract.exe %RAMD%:\ > NUL
copy readme.txt %RAMD%:\ > NUL
copy a:\command.com %RAMD%:\
copy a:\pkunzip.exe %RAMD%:\
copy a:\initool.exe %RAMD%:\

%RAMD%:
cd\
md dos
md net
md temp

copy a:\dos\*.* %RAMD%:\dos\*.*
copy a:\net.zip %RAMD%:\

%RAMD%:\pkunzip.exe -o -d %RAMD%:\net.zip %RAMD%:\net
LH %ramd%:\dos\MSCDEX.EXE /D:mscd001 /L:%CDROM%
path=%RAMD%:\;%RAMD%:\DOS


set setip=no
set domname=mshome
set pcname=PCXP
set pathname=\\servername\sharename
set acctname=[computer\username]
set pass=[password]
set nicchoice=PXE
set nicdriver=e100b.dos

set ip=DHCP
set subnet=DHCP
set gateway=DHCP

%RAMD%:\INITOOL.EXE PUT "network" computername %pcname% /I=%RAMD%:\NET\SYSTEM.INI /O
%RAMD%:\INITOOL.EXE PUT "network" username %acctname% /I=%RAMD%:\NET\SYSTEM.INI /O
%RAMD%:\INITOOL.EXE PUT "network" workgroup %domname% /I=%RAMD%:\NET\SYSTEM.INI /O
%RAMD%:\INITOOL.EXE PUT "network" logondomain %domname% /I=%RAMD%:\NET\SYSTEM.INI /O
%RAMD%:\INITOOL.EXE PUT "network" lanroot %RAMD%:\net /I=%RAMD%:\NET\SYSTEM.INI /O
%RAMD%:\INITOOL.EXE PUT "network drivers" devdir %RAMD%:\net /I=%RAMD%:\NET\SYSTEM.INI /O


%RAMD%:\INITOOL.EXE PUT "network drivers" netcard e100b.dos /I=%RAMD%:\NET\SYSTEM.INI /O
%RAMD%:\INITOOL.EXE PUT "network.setup" netcard ms$ndis,1,MS$ndis,1 /I=%RAMD%:\NET\PROTOCOL.INI /O
%RAMD%:\INITOOL.EXE PUT "network.setup" lana0 ms$ndis,1,tcpip /i=%RAMD%:\net\protocol.ini /O
%RAMD%:\INITOOL.EXE PUT "tcpip" BINDINGS MS$NDIS /I=%RAMD%:\NET\PROTOCOL.INI /O


%RAMD%:
cd\
cd net

net initialize
netbind.com
umb.com
tcptsr.exe
tinyrfc.exe
nmtsr.exe
emsbfr.exe
rem %drive%\net\net start

echo.
echo Logging into %domname% as %acctname%...
NET LOGON %acctname% %pass% /YES /SAVEPW:NO
echo.
echo Mapping drive I: to %pathname%...
net use I: %pathname%


