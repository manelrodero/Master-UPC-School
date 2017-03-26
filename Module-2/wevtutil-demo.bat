@echo off

wevtutil qe Application /c:3 /rd:true /f:text
echo.
echo - Obtiene los 3 eventos mas recientes del log Application en formato texto
echo   wevtutil qe Application /c:3 /rd:true /f:text
pause&cls

wevtutil qe System /q:"*[System[(EventID=7040)]]" /c:3 /f:text /rd:true
echo.
echo - Los 3 eventos mas recientes con ID=7040 del log System en formato texto
echo   wevtutil qe System /q:"*[System[(EventID=7040)]]" /c:3 /f:text /rd:true
pause&cls

wevtutil qe system "/q:*[System[(Level=2)]]" /f:text /c:3 /rd:true
echo.
echo - Los 3 eventos de tipo error mas recientes
echo   wevtutil qe system "/q:*[System[(Level=2)]]" /f:text /c:3 /rd:true
pause&cls

wevtutil el
echo.
echo - Listar los archivos de registro
echo   wevtutil el
pause&cls

wevtutil gl Application
echo.
echo - Obtener la configuracion del archivo de registro
echo   wevtutil gl Application
pause&cls

if exist export-backup.evtx del export-backup.evtx
wevtutil epl microsoft-windows-backup export-backup.evtx
dir export-backup.evtx
echo.
echo - Exportar un fichero de log en formato *.evtx
echo   wevtutil epl microsoft-windows-backup export-backup.evtx
pause&cls
