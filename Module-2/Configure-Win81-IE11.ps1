# Script de Configuración de Windows 8.1 IE11

# Actualización de la ayuda de PowerShell
Write-Host "Actualizando ayuda de PowerShell" -ForegroundColor Green
Update-Help

# Cmdlets para internacionalización
# https://technet.microsoft.com/en-us/library/hh852115.aspx

# Get-Command -Module International
# [System.Globalization.CultureInfo]::GetCultures('InstalledWin32Cultures')

# Cambio del teclado en-US a es-ES ;-)
Write-Host "Cambiando teclado a es-ES" -ForegroundColor Green
Set-WinUserLanguageList -LanguageList es-ES -Force
