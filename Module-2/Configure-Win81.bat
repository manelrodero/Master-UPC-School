@ECHO OFF

:: Wrapper para descargar y ejecutar el script de configuración de la VM Win81 IE11

copy nul %~n0.ps1 > nul

sc.exe config wuauserv start= disabled > nul
sc.exe config WSearch start= disabled > nul
sc.exe stop wauserv > nul
sc.exe stop wsearch > nul
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f > nul

:: GitHub elimina TLS1.0 y TLS1.1 (https://githubengineering.com/crypto-removal-notice/)
>> %~n0.ps1 echo [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
>> %~n0.ps1 echo Invoke-Expression (New-Object Net.WebClient).DownloadString('https://github.com/manelrodero/Master-UPC-School/raw/master/Module-2/Configure-Win81-IE11.ps1')

PowerShell -NoProfile -ExecutionPolicy Bypass .\%~n0.ps1

rem del %~n0.ps1