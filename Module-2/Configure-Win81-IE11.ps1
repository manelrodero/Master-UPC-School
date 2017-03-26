# Script de Configuración de Windows 8.1 IE11

# Configuración de la zona horaria
tzutil /s "Romance Standard Time" 
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sShortTime -Value H:mm
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sTimeFormat -Value H:mm:ss
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sShortDate -Value d/M/yyyy
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name iFirstDayOfWeek -Value 0

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
if (!(Test-Path -Path "$DesktopFolder")) { mkdir "$DesktopFolder" | Out-Null }
if (!(Test-Path -Path "$DesktopFolder\Downloads")) { mkdir "$DesktopFolder\Downloads" | Out-Null }

# Tres métodos distintos para descargar ficheros en PowerShell
# https://blog.jourdant.me/post/3-ways-to-download-files-with-powershell

# Descarga 7-Zip
$progDownload = "7z1604.msi"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando 7-Zip ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest http://www.7-zip.org/a/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "7-Zip ya estaba descargado" -ForegroundColor Yellow
}

# Instalación de 7-Zip
Write-Host "Instalando 7-Zip ... " -ForegroundColor Green -NoNewline
msiexec.exe /i "$DesktopFolder\Downloads\$progDownload" /passive
Write-Host "OK" -ForegroundColor Yellow

# Descarga Git-Portable
$progDownload = "PortableGit-2.12.1-32-bit.7z.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Git-Portable ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.12.1.windows.1/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Git-Portable ya esta descargado" -ForegroundColor Yellow
}

# Instalación de Git-Portable
Write-Host "Descomprimiendo Git Portable ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\Git") { Remove-Item -Path "$DesktopFolder\Git" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" x -o"$DesktopFolder\Git" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga Sysinternals Suite
$progDownload = "SysinternalsSuite.zip"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Sysinternals Suite ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://download.sysinternals.com/files/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "SysinternalsSuite ya esta descargado" -ForegroundColor Yellow
}

# Instalación de Sysinternals Suite
Write-Host "Descomprimiendo Sysinternals Suite ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\Sysinternals") { Remove-Item -Path "$DesktopFolder\Sysinternals" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" x -o"$DesktopFolder\Sysinternals" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga NirCmd
$progDownload = "nircmd.zip"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando NirCmd ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest http://www.nirsoft.net/utils/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "NirCmd ya esta descargado" -ForegroundColor Yellow
}

# Instalación de NirCmd
Write-Host "Descomprimiendo NirCmd ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\Nirsoft") { Remove-Item -Path "$DesktopFolder\Nirsoft" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" x -o"$DesktopFolder\Nirsoft" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga Hstart
$progDownload = "Hstart_4.3-setup.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Hstart ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest http://www.ntwind.com/download/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Hstart ya esta descargado" -ForegroundColor Yellow
}

# Instalación de Hstart
Write-Host "Descomprimiendo Hstart ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\Hstart") { Remove-Item -Path "$DesktopFolder\Hstart" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" x -o"$DesktopFolder\Hstart" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga scripts del Máster
if (!(Test-Path -Path "$DesktopFolder\Scripts")) { mkdir "$DesktopFolder\Scripts" | Out-Null }
& "$DesktopFolder\Git\bin\git.exe" clone https://github.com/manelrodero/Master-UPC-School.git "$DesktopFolder\Scripts"

# Creación carpeta C:\TEST
if (!(Test-Path -Path "C:\TEST")) { mkdir "C:\TEST" | Out-Null }

# Final del script (evitar que se cierre)
Write-Host "Pulsa una tecla para continuar ..."
$tecla=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
