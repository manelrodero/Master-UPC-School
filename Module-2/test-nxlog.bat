@echo off

net session >nul 2>&1
if not "%errorLevel%" == "0" (
    echo Es necesario ejecutar el script como Administrador!
    pause
    exit /b %errorLevel%
)

echo Instalando NXLog-CE...
msiexec /passive /i "C:\Users\IEUser\Desktop\MASTER\Downloads\nxlog-ce-2.9.1716.msi"

echo Copiando script nxlog.conf...
copy /y "C:\Users\IEUser\Desktop\MASTER\Scripts\Module-2\nxlog.conf" "%ProgramFiles%\nxlog\conf\nxlog.master.conf" >nul 2>&1

echo.
echo Es necesario editar "%ProgramFiles%\nxlog\conf\nxlog.conf":
echo 1 - Agregar la IP del Syslog remoto usando protocolo UDP
echo 2 - Reiniciar el servicio 'nxlog'
pause
start "" notepad.exe "%ProgramFiles%\nxlog\conf\nxlog.conf"
