# Script de Configuración de Windows 2012 R2

# Configuración de la zona horaria
tzutil /s "Romance Standard Time" 
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sShortTime -Value H:mm
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sTimeFormat -Value H:mm:ss
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sShortDate -Value d/M/yyyy
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name iFirstDayOfWeek -Value 0

# Actualización de la ayuda de PowerShell
# Write-Host "Actualizando ayuda de PowerShell" -ForegroundColor Green
# Update-Help

# Cmdlets para internacionalización
# https://technet.microsoft.com/en-us/library/hh852115.aspx
# Get-Command -Module International
# [System.Globalization.CultureInfo]::GetCultures('InstalledWin32Cultures')

# Cambio del teclado en-US a es-ES ;-)
Write-Host "Cambiando teclado a es-ES" -ForegroundColor Green
Set-WinUserLanguageList -LanguageList es-ES -Force

# Deshabilitar instalación automática de actualizaciones
Write-Host "Deshabilitando Auto Update (Microsoft Update)" -ForegroundColor Green
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'AUOptions' -Value 2
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'CachedAUOptions' -Value 2
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'IncludeRecommendedUpdates' -Value 1

# Deshabilitar SMBv1 (WannaCry)
Write-Host "Deshabilitando SMBv1" -ForegroundColor Green
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force > $null
sc.exe config lanmanworkstation depend= bowser/mrxsmb20/nsi > $null
sc.exe config mrxsmb10 start= disabled > $null

# Deshabilitar IPv6 y Teredo
reg.exe add hklm\system\currentcontrolset\services\tcpip6\parameters /v DisabledComponents /t REG_DWORD /d 0xffffffff /f > $null
netsh.exe interface teredo set state disabled > $null

# Final del script (evitar que se cierre)
Write-Host "Pulsa una tecla para reiniciar el equipo ..."
$tecla = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Restart-Computer -Force
