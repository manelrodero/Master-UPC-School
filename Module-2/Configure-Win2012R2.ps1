# Script de Configuración de Windows 2012 R2

# Configuración de la zona horaria
tzutil /s "Romance Standard Time" 
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sShortTime -Value H:mm
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sTimeFormat -Value H:mm:ss
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sShortDate -Value d/M/yyyy
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name iFirstDayOfWeek -Value 0

# Actualización de la ayuda de PowerShell
Write-Host "Actualizando ayuda de PowerShell" -ForegroundColor Green
Update-Help -ErrorAction SilentlyContinue

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
# https://support.microsoft.com/en-us/help/929852/guidance-for-configuring-ipv6-in-windows-for-advanced-users
reg.exe add hklm\system\currentcontrolset\services\tcpip6\parameters /v DisabledComponents /t REG_DWORD /d 0xFF /f > $null
netsh.exe interface teredo set state disabled > $null

# Obtención de la ubicación de carpetas especiales
# http://windowsitpro.com/powershell/easily-finding-special-paths-powershell-scripts
# [Environment+SpecialFolder]::GetNames([Environment+SpecialFolder])

# Creación de la carpeta MASTER en el escritorio
Write-Host "Creando carpeta MASTER" -ForegroundColor Green
$DesktopFolder = "$([Environment]::GetFolderPath("Desktop"))\MASTER"
if (!(Test-Path -Path "$DesktopFolder")) { mkdir "$DesktopFolder" | Out-Null }
if (!(Test-Path -Path "$DesktopFolder\Downloads")) { mkdir "$DesktopFolder\Downloads" | Out-Null }

# Descarga VirtualBox SHA Certs
$progDownload = "vbox-sha1.cer"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando VirtualBox SHA1 Cert ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EbAf4B88tcVKpjEUXKhVixoBjkWrdhk5wyCRopdMs4CLZw?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "VirtualBox SHA1 Cert ya esta descargado" -ForegroundColor Yellow
}

$progDownload = "vbox-sha256.cer"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando VirtualBox SHA256 Cert ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/ERAUDOeshGlDviL61DwcUIUBaY2n3qj9uNswfgwCGfNfvg?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "VirtualBox SHA256 Cert ya esta descargado" -ForegroundColor Yellow
}

$progDownload = "VBoxCertUtil.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando VirtualBox Cert Utility ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EXp0uO3MJ6tJiBiQytsWa3YBiaN2DhZh_9der73F64ylKw?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "VirtualBox Cert Utility ya esta descargado" -ForegroundColor Yellow
}

# Instalación de VirtualBox SHA Certs
Write-Host "Instalando VirtualBox SHA Certs ... " -ForegroundColor Green -NoNewline
& "$DesktopFolder\Downloads\$progDownload" add-trusted-publisher "$DesktopFolder\Downloads\vbox-sha1.cer" --root "$DesktopFolder\Downloads\vbox-sha1.cer" | Out-Null
& "$DesktopFolder\Downloads\$progDownload" add-trusted-publisher "$DesktopFolder\Downloads\vbox-sha256.cer" --root "$DesktopFolder\Downloads\vbox-sha256.cer" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga VirtualBox Guest Additions
$progDownload = "VBoxWindowsAdditions-amd64.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando VirtualBox GA x64 ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/ERjPYcdfX4tHnXrAxHko2pEBOvBCH097fzrLoeahUb6zBw?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "VirtualBox GA x64 ya esta descargado" -ForegroundColor Yellow
}

$progDownload = "VBoxWindowsAdditions.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando VirtualBox GA ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EQCzmYyhAUdAoaEzrKAuNscB86Y9A6fLYHlAXz8XMnRPnA?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "VirtualBox GA ya esta descargado" -ForegroundColor Yellow
}

# Instalación de VirtualBox Guest Additions
Write-Host "Instalando VirtualBox Guest Additions ... " -ForegroundColor Green -NoNewline
& "$DesktopFolder\Downloads\$progDownload" /S
Write-Host "OK" -ForegroundColor Yellow

# Final del script (evitar que se cierre)
Write-Host "Pulsa una tecla para apagar el equipo ..."
$tecla = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Stop-Computer -Force
