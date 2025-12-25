@echo off
::bobjohnson:02 - http://www.svrops.com/svrops/dwnlddisk.htm
::Connecting to a NT4.0/2000 Server/Domain

::09.02 - I added a PC Name to the list of information to be entered.
::If you will be doing an unattended install of Windows 2000 or XP,
::you have to have a PC Name (computername) entry in the System.ini file
::An unattended install of NT 4.0 does not require this, and it won't hurt
::if it is there.

::Xmsdsk.exe is used to create a RAM Drive and is
::loaded in autoexec.bat.  Alternatively, Microsoft Ramdrive.sys can
::be used, and loaded in config.sys.
::Xmsdsk.exe allows you to choose which drive will be the RAM drive,
::MS Ramdrive.sys does not.

::Files are copied to the RAM Drive instead of the hard drive.
::It's faster and Hard Drive cleanup is unnecessary after the
::install with a RAM Disk.

::Ansi.sys is used in config.sys to add color.
::You can remove this if you would rather have
::plain DOS colors.  You should also remove the
::ansi color commands in this file too.  Some are
::commented, and they look like this... echo [1;37;44m).

::You can add/delete network card support very easily.
::It is assumed you have some knowledge of DOS Batch File
::programming.
::Scroll down to the NETWORK CARD section for details

::This program support both DHCP and Static IP addresses

::Feel free to modify this program
::in any way that makes it easier for you.
::If you know of a way to improve the program,
::please let me know.



@call a:\dos\color.bat       REM changes screen to white on blue
cls
echo.
::Create Xmsdsk RAM Disk
echo Creating RAM Disk... Drive M: will be used
set drive=M:
a:\xmsdsk.exe 4096 %drive% /y >nul

path=a:\;a:\dos
a:\dos\smartdrv.exe /q
prompt=$p$g
goto COPYFILES

:COPYFILES
cls
echo.
echo.
echo      ***** Connecting to a NT/2000 Domain *****
echo.
echo.
echo      Preparing RAM Drive for connecting to a NT/2000 Domain...

%drive%
cd\
md dos
md net
md temp

if not exist %drive%\dos\CON goto NODIR
if not exist %drive%\net\CON goto NODIR
if not exist %drive%\temp\CON goto NODIR

set temp=%drive%\temp
set tmp=%drive%\temp
set path=
set path=%drive%\;%drive%\dos;%drive%\net;a:\;a:\dos

a:\
@echo on
copy a:\command.com %drive%\
copy a:\pkunzip.exe %drive%\
copy a:\initool.exe %drive%\
copy a:\dos\choice.com %drive%\dos
copy a:\dos\format.com %drive%\dos
copy a:\dos\putinenv.exe %drive%\dos
copy a:\dos\yn.com %drive%\dos
copy a:\dos\xcopy.exe %drive%\dos
copy a:\dos\fdisk.exe %drive%\dos
copy a:\net.zip %drive%\

@echo off
cls
echo.
::Unzip files for MS network connection:
%drive%\pkunzip.exe -o -d net.zip %drive%\net
if not exist %drive%\net\protocol.ini goto NODIR


cls
echo  bjohnson:02 
echo.
echo       ***** Connecting to a NT/2000 Domain *****
echo.
echo.
echo       You will need the following information:
echo.        
echo         1. The type of Network Card in this PC.
echo         2. A name for this PC (any name is fine).
echo         3. The name of the Domain you will login to.
echo         4. A user name and password to login to the Domain.
echo         5. A UNC path to a server share, e.g. \\server1\apps
echo         6. If your network is Not using DHCP, you will need IP Address Info.
echo.
echo       Do you want to continue (Y/N)?
echo.
%drive%\dos\yn.com
if not errorlevel 1 goto STOP

       
cls
echo.
echo       ***** Connecting to a NT/2000 Domain *****
echo.
echo.
echo       Does your Network use DHCP (Dynamic IP Addressing)?
echo.        
echo.
%drive%\dos\choice /c:YN  "      Enter your selection  "

if errorlevel 2 goto YESIP
if errorlevel 1 if not errorlevel 2 goto NOIP

:YESIP
set setip=yes
::The following environmental variable is needed to modify the Protocol.ini file
set dhcp=1
goto START

:NOIP
set setip=no
goto START


:START
cls
echo. 
echo.
echo      ***** Connecting to a NT/2000 Domain *****
echo.
echo.
goto GETDOMAIN


:GETDOMAIN
::echo.
::PUTINENV P "Enter the name of the Domain to login to: " 50
::if not "%string%"=="" goto DOMGOOD
::echo.
::echo You must enter a Domain name to proceed.
::goto GETDOMAIN
:DOMGOOD
set domname=mshome
goto GETPCNAME

:GETPCNAME
cls
echo.
echo.
echo      ***** Connecting to a NT/2000 Domain *****
echo.
echo.
echo.
::PUTINENV P "Enter a name for this PC: " 15
::if not "%string%"=="" goto NAMEGOOD
::echo.
::echo You must enter a PC name to proceed.
::goto GETPCNAME
:NAMEGOOD
set pcname=PCXP
goto GETPATH

:GETPATH
cls
echo.
echo.
echo      ***** Connecting to a NT/2000 Domain *****
echo.
echo.
echo.
::PUTINENV P "Enter a UNC Path to a Server share: " 50
::if not "%string%"=="" goto PATHGOOD
::echo.
::echo You must enter a Path to proceed.
::goto GETPATH
:PATHGOOD
set pathname=\\ICMQK96\pxeshare
goto GETACCTNAME

:GETACCTNAME
cls
echo.
echo.
echo      ***** Connecting to a NT/2000 Domain *****
echo.
echo.
echo.
::PUTINENV P "Enter a User Name for %domname%: " 15
::if not "%string%"=="" goto ACCTGOOD
::echo.
::echo You must enter a User Name to proceed.
::goto GETACCTNAME
:ACCTGOOD
set acctname=[computername\username]
goto PASSWORD

:PASSWORD
cls
echo.
echo.
echo      ***** Connecting to a NT/2000 Domain *****
echo.
echo.
echo.
::PUTINENV Q "Enter the Password for %acctname% on %domname%: " 20
set pass=password
::goto PASSGOOD
::echo.
::echo You must enter a Password to proceed.
::goto PASSWORD
:PASSGOOD
::PUTINENV Q "Re-enter the Password for %acctname% on %domname%: " 20
::if "%string%"=="%pass%" goto GETNIC
::echo.
::echo Password not retyped exactly the same.  Press any key to re-enter.
::pause>nul
::goto PASSWORD

:GETNIC
::If you are adding/deleting a network card, change this
::menu and the errorlevel statments below it to reflect
::the change.
cls
echo.
echo.
echo    Please choose which type of Network Card this PC has:
echo.
echo    1.  IBM 100/10 PCI Ethernet (IBMFE.DOS)
echo    2.  3COM 10/100 3C9x Ethernet (EL90X.DOS)
echo    3.  Compaq 10/100 (N100.DOS)
echo    4.  Madge Smart 16/4 TR-BM2 (MDGND.DOS)
echo    5.  NDIS driver
echo.
%drive%\dos\choice /c:12345 "   Enter your selection  "

if not errorlevel==5 goto TRY4
set nicchoice=PXE
set nicdriver=e100b.dos
goto CHKIP
:TRY4
if not errorlevel==4 goto TRY3
set nicchoice=MADGE
set nicdriver=MDGND.DOS
goto CHKIP
:TRY3
if not errorlevel==3 goto TRY2
set nicchoice=COMPAQ
set nicdriver=N100.DOS
goto CHKIP
:TRY2
if not errorlevel==2 goto TRY1
set nicchoice=3COM
set nicdriver=EL90X.DOS
goto CHKIP
:TRY1
if not errorlevel==1 goto BAD
set nicchoice=IBM
set nicdriver=IBMFE.DOS
goto CHKIP

:BAD
echo.
echo You must choose one of the NIC types presented.
goto GETNIC


:CHKIP
::Check to see if using static IP addressing
If %setip% == no goto DHCP
If %setip% == yes goto GETIP

:DHCP
set ip=DHCP
set subnet=DHCP
set gateway=DHCP
goto CHKCHOICE

:GETIP
cls
echo.
REM change text to yellow
echo [1;33;44m   

echo   *Use the Spacebar instead of periods entering the address*

REM change text to white
echo [1;37;44m   

PUTINENV P "Enter the IP Address this PC will use: " 15
if not "%string%"=="" goto IPGOOD
echo.
echo You must enter an IP Address to proceed.
goto GETIP
:IPGOOD
set ip=%string%
goto GETSUBNET

:GETSUBNET
cls
echo.

REM change text to yellow
echo [1;33;44m      

echo   *Use the Spacebar instead of periods entering the address*

REM change text to white
echo [1;37;44m      

PUTINENV P "Enter the Subnet Mask this PC will use: " 15
if not "%string%"=="" goto SUBGOOD
echo.
echo You must enter an Subnet Mask to proceed.
goto GETSUBNET
:SUBGOOD
set subnet=%string%
goto GETDEFAULT

:GETDEFAULT
cls
echo.

REM change text to yellow
echo [1;33;44m   
   
echo   *Use the Spacebar instead of periods entering the address*

REM change text to white
echo [1;37;44m    

PUTINENV P "Enter the Default Gateway this PC will use: " 15
if not "%string%"=="" goto DEFGOOD
echo.
echo You must enter a Default Gateway to proceed.
goto GETDEFAULT
:DEFGOOD
set gateway=%string%
goto CHKCHOICE


:CHKCHOICE
cls
echo.
echo.
echo        ***** Connecting to a NT/2000 Domain *****
echo.
echo.
echo     You have chosen the following settings:
echo.
echo [1;37;44m IP Address:       [1;33;44m %ip%
echo [1;37;44m Subnet Mask:      [1;33;44m %subnet%
echo [1;37;44m Default Gateway:  [1;33;44m %gateway%
echo.
echo [1;37;44m NT Domain:      [1;33;44m %domname%
echo [1;37;44m PC Name:        [1;33;44m %pcname%
echo [1;37;44m NT UNC Path:    [1;33;44m %pathname%
echo [1;37;44m User ID:        [1;33;44m %acctname%
echo [1;37;44m Network Card:   [1;33;44m %nicchoice% (%nicdriver%)
echo.
%drive%\dos\choice Is this correct (a reply of "no" will restart from the beginning)

REM change text to white
echo [1;37;44m

if errorlevel==2 goto START
goto IPSETTINGS


:IPSETTINGS
::Modify System.ini and Protocol.ini files based on user selections

If %setip% == yes goto CHANGEIP
If %setip% == no goto CHANGEINI

:CHANGEIP
%drive%\INITOOL.EXE PUT "tcpip" DefaultGateway0 "%gateway%" /I=%drive%\NET\PROTOCOL.INI /O
%drive%\INITOOL.EXE PUT "tcpip" SubNetMask0 "%subnet%" /I=%drive%\NET\PROTOCOL.INI /O
%drive%\INITOOL.EXE PUT "tcpip" IPAddress0 "%ip%" /I=%drive%\NET\PROTOCOL.INI /O
%drive%\INITOOL.EXE PUT "tcpip" DisableDHCP "%dhcp%" /I=%drive%\NET\PROTOCOL.INI /O
goto CHANGEINI


:CHANGEINI
%drive%\INITOOL.EXE PUT "network" computername %pcname% /I=%drive%\NET\SYSTEM.INI /O
%drive%\INITOOL.EXE PUT "network" username %acctname% /I=%drive%\NET\SYSTEM.INI /O
%drive%\INITOOL.EXE PUT "network" workgroup %domname% /I=%drive%\NET\SYSTEM.INI /O
%drive%\INITOOL.EXE PUT "network" logondomain %domname% /I=%drive%\NET\SYSTEM.INI /O
%drive%\INITOOL.EXE PUT "network" lanroot %drive%\net /I=%drive%\NET\SYSTEM.INI /O
%drive%\INITOOL.EXE PUT "network drivers" devdir %drive%\net /I=%drive%\NET\SYSTEM.INI /O


::**NETWORK CARDS**
::The sections below are where you can add or delete network cards.
::You need to have added your network card DOS driver file
::to the net.zip file first, then add a line for the network card,
::e.g.  if "%nicchoice%" == "NEWCARD" goto NEWCARD
::Next, create a subsection for the network card by copying and
::pasting one of the existing network card subsections below.  Change
::each instance of the DOS driver name in the new section.  Be careful not
::to change anything else.
::You also need to add (or change) a menu option under the :GETNIC 
::subsection further up in this file.
::In the Protocol.ini file add a section for the network card.  It will
::look like this:

::[ms$ibmfe]
::drivername=IBMFE$

::This is for an IBM 10/100 Etherjet card.  For example, if you were
::adding a 3COM 3c90x card, you would replace ibmfe with el90x,
::leave the rest as is.

if "%nicchoice%" == "NDIS" goto NDIS
if "%nicchoice%" == "MADGE" goto MADGE
if "%nicchoice%" == "COMPAQ" goto COMPAQ
if "%nicchoice%" == "3COM" goto 3COM
if "%nicchoice%" == "IBM" goto IBM

:NDIS
%drive%\INITOOL.EXE PUT "network drivers" netcard e100b.dos /I=%drive%\NET\SYSTEM.INI /O
%drive%\INITOOL.EXE PUT "network.setup" netcard ms$ndis,1,MS$ndis,1 /I=%drive%\NET\PROTOCOL.INI /O
%drive%\INITOOL.EXE PUT "network.setup" lana0 ms$ndis,1,tcpip /i=%drive%\net\protocol.ini /O
%drive%\INITOOL.EXE PUT "tcpip" BINDINGS MS$NDIS /I=%drive%\NET\PROTOCOL.INI /O
goto NETCONNECT

:MADGE
%drive%\INITOOL.EXE PUT "network drivers" netcard MDGND.DOS /I=%drive%\NET\SYSTEM.INI /O
%drive%\INITOOL.EXE PUT "network.setup" netcard ms$mdgnd,1,MS$mdgnd,1 /I=%drive%\NET\PROTOCOL.INI /O
%drive%\INITOOL.EXE PUT "network.setup" lana0 ms$mdgnd,1,tcpip /i=%drive%\net\protocol.ini /O
%drive%\INITOOL.EXE PUT "tcpip" BINDINGS MS$MDGNT /I=%drive%\NET\PROTOCOL.INI /O
goto NETCONNECT

:COMPAQ
%drive%\INITOOL.EXE PUT "network drivers" netcard N100.DOS /I=%drive%\NET\SYSTEM.INI /O
%drive%\INITOOL.EXE PUT "network.setup" netcard ms$n100,1,MS$N100,1 /I=%drive%\NET\PROTOCOL.INI /O
%drive%\INITOOL.EXE PUT "network.setup" lana0 ms$n100,1,tcpip /i=%drive%\net\protocol.ini /O
%drive%\INITOOL.EXE PUT "tcpip" BINDINGS MS$N100 /I=%drive%\NET\PROTOCOL.INI /O
goto NETCONNECT

:3COM
%drive%\INITOOL.EXE PUT "network drivers" netcard EL90X.DOS /I=%drive%\NET\SYSTEM.INI /O
%drive%\INITOOL.EXE PUT "network.setup" netcard ms$el90x,1,MS$EL90X,1 /I=%drive%\NET\PROTOCOL.INI /O
%drive%\INITOOL.EXE PUT "network.setup" lana0 ms$el90x,1,tcpip /i=%drive%\net\protocol.ini /O
%drive%\INITOOL.EXE PUT "tcpip" BINDINGS MS$EL90X /I=%drive%\NET\PROTOCOL.INI /O
goto NETCONNECT

:IBM
%drive%\INITOOL.EXE PUT "network drivers" netcard IBMFE.DOS /I=%drive%\NET\SYSTEM.INI /O
%drive%\INITOOL.EXE PUT "network.setup" netcard ms$ibmfe,1,MS$ibmfe,1 /I=%drive%\NET\PROTOCOL.INI /O
%drive%\INITOOL.EXE PUT "network.setup" lana0 ms$ibmfe,1,tcpip /i=%drive%\net\protocol.ini /O
%drive%\INITOOL.EXE PUT "tcpip" BINDINGS MS$IBMFE /I=%drive%\NET\PROTOCOL.INI /O
goto NETCONNECT


:NETCONNECT
cls
echo.
echo.
echo       ***** Connecting to a NT/2000 Domain *****
echo.
echo       Preparing to Connect to the Network...
echo.
%drive%
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


::Cleanup
set string=
set pass=

::echo   Connected To Domain
pause
i:
cd\
goto END



::<---Error Messages--->


:NODIR
cls
echo.
echo.
echo   Unable to create needed directories.
echo   Please Reboot the PC and try again.
goto DONE

:STOP
cls
echo.
echo.
echo   User Terminated Setup.
echo   End of Program.
echo   Warm boot PC to restart program
goto DONE

:NODRIVE
echo.
echo.
echo   No RAM Drive found in Memory.
echo   Please reboot the PC and try again.
goto DONE


:DONE
a:
cd\
if exist a:\flag\menu.txt del a:\flag\menu.txt > nul
if exist a:\flag\fdisk.txt del a:\flag\fdisk.txt > nul
pause

:END



