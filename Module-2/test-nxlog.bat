@echo off

net session >nul 2>&1
if not "%errorLevel%" == "0" (
    echo Es necesario ejecutar el script como Administrador!
    pause
    exit /b %errorLevel%
)

echo Instalando NXLog-CE...
:: Atención a la versión descargada mediante Configure-Win81-IE11.ps1
msiexec /passive /i "C:\Users\IEUser\Desktop\MASTER\Downloads\nxlog-ce-2.10.2150.msi"

echo Copiando script nxlog.conf...
copy /y "%ProgramFiles%\nxlog\conf\nxlog.conf" "%ProgramFiles%\nxlog\conf\nxlog.original.conf" >nul 2>&1
copy /y "C:\Users\IEUser\Desktop\MASTER\Scripts\Module-2\nxlog.conf" "%ProgramFiles%\nxlog\conf\nxlog.conf" >nul 2>&1

echo Reiniciando NXLog-CE...
net stop nxlog
net start nxlog
