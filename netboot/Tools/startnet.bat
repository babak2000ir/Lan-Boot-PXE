::copied from the default Autoexec.bat made from the NT Network
::Startup Disk creation process.
::these are the files needed to initialize and connect the PC to a NT domain
::using TCP/IP.


%drive%\net\net initialize
%drive%\net\netbind.com
%drive%\net\umb.com
%drive%\net\tcptsr.exe
%drive%\net\tinyrfc.exe
%drive%\net\nmtsr.exe
%drive%\net\emsbfr.exe
rem %drive%\net\net start

echo.
echo Logging into %domname% as %acctname%...
NET LOGON %acctname% %pass% /YES /SAVEPW:NO
