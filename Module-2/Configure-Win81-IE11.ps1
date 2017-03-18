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

# Deshabilitar instalación automática de actualizaciones
Write-Host "Deshabilitando Auto Update (Microsoft Update)" -ForegroundColor Green
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'AUOptions' -Value 2
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'CachedAUOptions' -Value 2
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'IncludeRecommendedUpdates' -Value 1

# Obtención de la ubicación de carpetas especiales
# http://windowsitpro.com/powershell/easily-finding-special-paths-powershell-scripts
# [Environment+SpecialFolder]::GetNames([Environment+SpecialFolder])

# Creación de la carpeta MASTER en el escritorio
Write-Host "Creando carpeta MASTER" -ForegroundColor Green
$DesktopFolder = "$([Environment]::GetFolderPath("Desktop"))\MASTER"
if (!(Test-Path -Path "$DesktopFolder")) { mkdir "$DesktopFolder" }

# Tres métodos distintos para descargar ficheros en PowerShell
# https://blog.jourdant.me/post/3-ways-to-download-files-with-powershell
# Descarga Git-Portable
Write-Host "Descargando Git-Portable ... " -ForegroundColor Green -NoNewline
$start_time = Get-Date
Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.12.0.windows.1/PortableGit-2.12.0-64-bit.7z.exe -OutFile "$DesktopFolder\PortableGit-2.12.0-32-bit.7z.exe"
Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow

# Descarga Git-Portable
Write-Host "Descargando 7-Zip ... " -ForegroundColor Green -NoNewline
$start_time = Get-Date
Invoke-WebRequest http://www.7-zip.org/a/7z1604.msi -OutFile "$DesktopFolder\7z1604.msi"
Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow

# Instalación de 7-Zip
Write-Host "Instalando 7-Zip ... " -ForegroundColor Green -NoNewline
msiexec.exe /i "$DesktopFolder\7z1604.msi" /passive
Write-Host "OK"-ForegroundColor Yellow

# Final del script (evitar que se cierre)
Write-Host "Pulsa una tecla para continuar ..."
$tecla=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
