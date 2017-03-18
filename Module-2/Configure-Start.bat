@ECHO OFF

:: Wrapper para descargar y ejecutar el script de configuración de la VM Win81 IE11

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/manelrodero/Master-UPC-School/start-edits/Module-2/Configure-Win81-IE11.ps1')"
