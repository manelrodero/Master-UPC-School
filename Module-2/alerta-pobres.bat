@echo off

pushd "%~pd0"

:: Opción 1
:: Escribir todos los valores que llegan como parámetros en un fichero alerta.log
echo %* >> "%~n0.log"

:: Opción 2
:: Generar un balloon con NirCmd (http://www.nirsoft.net/utils/nircmd.html)
:: Problema: Se queda TaskEng en ejecución hasta que desaparece el balloon
:: C:\Users\IEUser\Desktop\MASTER\Nirsoft\nircmd.exe trayballoon "Alerta de borrado: %5" "Se ha borrado el elemento %6" "shell32.dll,22" 15000

:: Opción 3
:: Usar Hstart para ocultar el TaskEng (http://www.ntwind.com/software/hstart.html)
:: Problema: Se sigue viendo el TaskEng como se abre y se cierra
:: C:\Users\IEUser\Desktop\MASTER\Hstart\hstart.exe /NOCONSOLE "C:\Users\IEUser\Desktop\MASTER\Nirsoft\nircmd.exe trayballoon "Alerta de borrado: %5" "Se ha borrado el elemento %6" "shell32.dll,22" 15000"

:: Opción 4
:: Modificar la tarea para que no llame a alerta.bat sino que utilice HStart directamente
:: C:\Users\IEUser\Desktop\MASTER\Nirsoft\nircmd.exe trayballoon "Alerta de borrado: %5" "Se ha borrado el elemento %6*" "shell32.dll,22" 15000

popd
