@echo off

wevtutil.exe sl Security /ab:true /rt:true
wevtutil.exe sl Application /ab:true /rt:true
echo.
echo - Se activa la retención y el archivado automático de los log Security y Application
echo   wevtutil.exe sl Security /ab:true /rt:true
echo   wevtutil.exe sl Application /ab:true /rt:true
pause&cls

wevtutil.exe qe Application /c:3 /rd:true /f:text
echo.
echo - Obtiene los 3 eventos mas recientes del log Application en formato texto
echo   wevtutil.exe qe Application /c:3 /rd:true /f:text
pause&cls

wevtutil.exe qe System /q:"*[System[(EventID=7040)]]" /c:3 /f:text /rd:true
echo.
echo - Los 3 eventos mas recientes con ID=7040 del log System en formato texto
echo   wevtutil.exe qe System /q:"*[System[(EventID=7040)]]" /c:3 /f:text /rd:true
pause&cls

wevtutil.exe qe system "/q:*[System[(Level=2)]]" /f:text /c:3 /rd:true
echo.
echo - Los 3 eventos de tipo error mas recientes
echo   wevtutil.exe qe system "/q:*[System[(Level=2)]]" /f:text /c:3 /rd:true
pause&cls

wevtutil.exe el
echo.
echo - Listar los archivos de registro
echo   wevtutil.exe el
pause&cls

wevtutil.exe gl Application
echo.
echo - Obtener la configuracion del archivo de registro
echo   wevtutil.exe gl Application
pause&cls

if exist export-backup.evtx del export-backup.evtx
wevtutil.exe epl microsoft-windows-backup export-backup.evtx
dir export-backup.evtx
echo.
echo - Exportar un fichero de log en formato *.evtx
echo   wevtutil.exe epl microsoft-windows-backup export-backup.evtx
pause&cls
