@ECHO OFF

SETLOCAL

ECHO -------------------------------------------------------------------------------
ECHO %~n0 - Configurador VirtualBox "NatVBox" en 10.0.20.0/24
ECHO -------------------------------------------------------------------------------
ECHO.

SET PROG=%ProgramFiles(x86)%\Oracle\VirtualBox\VBoxManage.exe
IF EXIST "%PROG%" GOTO OK
SET PROG=%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe
IF EXIST "%PROG%" GOTO OK

ECHO ERROR: No se ha encontrado VirtualBox. Es requisito imprescindible para este curso.
ECHO        Puedes instalarlo desde https://www.virtualbox.org/.
ECHO        No olvides instalar el Extension Pack.
PAUSE
GOTO :EOF

:OK

"%PROG%" list dhcpservers | find /i "NatVBox" >nul
IF "%ERRORLEVEL%"=="0" (
	"%PROG%" dhcpserver remove --netname NatVBox
)

"%PROG%" list natnets | find /i "NatVBox" >nul
IF "%ERRORLEVEL%"=="0" (
	"%PROG%" natnetwork stop --netname NatVBox
	"%PROG%" natnetwork remove --netname NatVBox
)

"%PROG%" natnetwork add --netname NatVBox --network "10.0.20.0/24" --enable --dhcp on
"%PROG%" natnetwork start --netname NatVBox
"%PROG%" dhcpserver modify --netname NatVBox --ip 10.0.20.3 --netmask 255.255.255.0 --lowerip 10.0.20.128 --upperip 10.0.20.254

"%PROG%" list natnets
"%PROG%" list dhcpservers
PAUSE

ENDLOCAL
