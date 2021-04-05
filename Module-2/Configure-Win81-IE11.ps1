# Script de Configuración de Windows 8.1 IE11

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

# Deshabilitar Windows Update
Write-Host "Deshabilitando Windows Update" -ForegroundColor Green
sc.exe config wuauserv start= disabled > $null

# Deshabilitar Windows Search
# https://lookeen.com/blog/how-to-disable-windows-search-in-windows-8-and-10
Write-Host "Deshabilitando Windows Search" -ForegroundColor Green
sc.exe config wsearch start= disabled > $null

# Deshabilitar Windows Defender
# https://www.windowscentral.com/how-permanently-disable-windows-defender-windows-10
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f > $null

# Deshabilitar SMBv1 (WannaCry)
Write-Host "Deshabilitando SMBv1" -ForegroundColor Green
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force > $null
sc.exe config lanmanworkstation depend= bowser/mrxsmb20/nsi > $null
sc.exe config mrxsmb10 start= disabled > $null

# Deshabilitar IPv6 y Teredo
reg.exe add hklm\system\currentcontrolset\services\tcpip6\parameters /v DisabledComponents /t REG_DWORD /d 0xffffffff /f > $null
netsh.exe interface teredo set state disabled > $null

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
$progDownload = "7z1900.msi"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando 7-Zip ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest http://www.7-zip.org/a/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    # https://drive.google.com/file/d/1Bp_rE_vRCbGr8iGGtmojyR_xQK40I3NI/view?usp=sharing
    # Invoke-WebRequest "https://drive.google.com/uc?id=1Bp_rE_vRCbGr8iGGtmojyR_xQK40I3NI&export=download" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/ER1cerdfnwlCoVP039dCXtcB4c0HZXzM41bLq3Hlt2bM6w?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "7-Zip ya estaba descargado" -ForegroundColor Yellow
}

# Instalación de 7-Zip
Write-Host "Instalando 7-Zip ... " -ForegroundColor Green -NoNewline
msiexec.exe /i "$DesktopFolder\Downloads\$progDownload" /passive
Write-Host "OK" -ForegroundColor Yellow

# Descarga LGPO 2.2
$progDownload = "LGPO.zip"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando LGPO ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    # https://drive.google.com/file/d/1T0JfNd1q0-l2b_22cbHZZuQu-6BvxWTy/view?usp=sharing
    # Invoke-WebRequest "https://drive.google.com/uc?id=1T0JfNd1q0-l2b_22cbHZZuQu-6BvxWTy&export=download" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/ESCNWTUFVb5EpqB2jjqGFm4BAfV4dPGSVkZUPAnVjTMtPg?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "LGPO ya estaba descargado" -ForegroundColor Yellow
}

# Instalación de LGPO
Write-Host "Descomprimiendo LGPO ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\LGPO") { Remove-Item -Path "$DesktopFolder\LGPO" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" x -o"$DesktopFolder\LGPO" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga Git-Portable
$progDownload = "PortableGit-2.24.0-32-bit.7z.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Git-Portable ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.16.2.windows.1/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    # https://drive.google.com/file/d/16kCANsKFKl8bmCwAh2E_Qq0hfMS2stsL/view?usp=sharing
    # Invoke-WebRequest "https://drive.google.com/uc?id=16kCANsKFKl8bmCwAh2E_Qq0hfMS2stsL&export=download" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EfFdiMcBHkJFvnQ9oxMRnrkBY435VSlzBElmHFX38DTW-g?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
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
    # Invoke-WebRequest https://download.sysinternals.com/files/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EY4Ou6ePzQ9Hq_w8NxcRNxcBFucXOgbiP9zRnODrIxtmwQ?e=PpKa0C?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "SysinternalsSuite ya esta descargado" -ForegroundColor Yellow
}

# Instalación de Sysinternals Suite
Write-Host "Descomprimiendo Sysinternals Suite ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\Sysinternals") { Remove-Item -Path "$DesktopFolder\Sysinternals" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" x -o"$DesktopFolder\Sysinternals" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga Notepad++
$progDownload = "npp.7.6.6.bin.7z"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Notepad++ ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest https://notepad-plus-plus.org/repository/7.x/7.6.6/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    # https://drive.google.com/file/d/11hr_YsdbNHQBFwbZyVlt9mNL-KQJ3Ydo/view?usp=sharing
    # Invoke-WebRequest "https://drive.google.com/uc?id=11hr_YsdbNHQBFwbZyVlt9mNL-KQJ3Ydo&export=download" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/ESDjdYD32xVKjqLIx-5CRwABhxpUwfbDSFmLNy185PgmvA?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Notepad++ ya esta descargado" -ForegroundColor Yellow
}

# Instalación de Notepad++
Write-Host "Descomprimiendo Notepad++ ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\Notepad++") { Remove-Item -Path "$DesktopFolder\Notepad++" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" x -o"$DesktopFolder\Notepad++" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga NirCmd
$progDownload = "nircmd.zip"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando NirCmd ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest http://www.nirsoft.net/utils/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    # https://drive.google.com/file/d/1BRQ-DCNY8cGrhA05GatnNLoHh2cEHl-C/view?usp=sharing
    # Invoke-WebRequest "https://drive.google.com/uc?id=1BRQ-DCNY8cGrhA05GatnNLoHh2cEHl-C&export=download" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EWxJUkyXsAtFvqV10ouf8eQBCvnL7YhJHUw6ypq4AIj51g?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "NirCmd ya esta descargado" -ForegroundColor Yellow
}

# Instalación de NirCmd
Write-Host "Descomprimiendo NirCmd ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\Nirsoft") { Remove-Item -Path "$DesktopFolder\Nirsoft" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" x -o"$DesktopFolder\Nirsoft" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

<#
# Descarga Hstart
$progDownload = "Hstart_4.8-setup.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Hstart ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://www.ntwind.com/download/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Hstart ya esta descargado" -ForegroundColor Yellow
}

# Instalación de Hstart
Write-Host "Descomprimiendo Hstart ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\Hstart") { Remove-Item -Path "$DesktopFolder\Hstart" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" x -o"$DesktopFolder\Hstart" -y "$DesktopFolder\Downloads\$progDownload" "hstart.exe" | Out-Null
Write-Host "OK" -ForegroundColor Yellow
#>

# Descarga Logger
$progDownload = "logger.zip"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Logger ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest http://www.monitorware.com/en/logger/download.asp -OutFile "$DesktopFolder\Downloads\$progDownload"
    # https://drive.google.com/file/d/1ffUCVQvMmu0fldYy9sHn1OBYlRjuozN5/view?usp=sharing
    # Invoke-WebRequest "https://drive.google.com/uc?id=1ffUCVQvMmu0fldYy9sHn1OBYlRjuozN5&export=download" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/ERdFXmIEdddFjLcIdMyGH5YBfJjKa7vvMvLzVTQ8wmQwvQ?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Logger ya esta descargado" -ForegroundColor Yellow
}

# Instalación de Logger
Write-Host "Descomprimiendo Logger ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\Logger") { Remove-Item -Path "$DesktopFolder\Logger" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" x -o"$DesktopFolder\Logger" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga Event to Syslog
$progDownload = "Evtsys_4.5.1_32-Bit-LP.zip"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Event to Syslog ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/eventlog-to-syslog/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    # https://drive.google.com/file/d/0B8uAnbkX5CZXekk0MkJ2cFVEZ0U/view?usp=sharing
    # Invoke-WebRequest "https://drive.google.com/uc?id=0B8uAnbkX5CZXekk0MkJ2cFVEZ0U&export=download" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EXAtbXhc_AZDuwD8Pcx8xjoBvsP4EtrUSROq9Q3EUoiOXA?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Event to Syslog ya esta descargado" -ForegroundColor Yellow
}

# Instalación de Event to Syslog
Write-Host "Descomprimiendo Event to Syslog ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\EventSyslog") { Remove-Item -Path "$DesktopFolder\EventSyslog" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" e -o"$DesktopFolder\EventSyslog" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga NXLog-CE (si cambia la versión, hay que modificar fichero "test-nxlog.bat")
$progDownload = "nxlog-ce-2.10.2150.msi"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando NXLog-CE ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest https://nxlog.co/system/files/products/files/348/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    # https://drive.google.com/file/d/1b_bxmZ41GFT0LLGGrXizqNL5bxyQh0gQ/view?usp=sharing
    # Invoke-WebRequest "https://drive.google.com/uc?id=1b_bxmZ41GFT0LLGGrXizqNL5bxyQh0gQ&export=download" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EcaXkrQuqDNGlAK0_1bNcBsB9K1xxBVzsd-GyngyqHT7Gw?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "NXLog-CE ya esta descargado" -ForegroundColor Yellow
}

# Descarga Visual Syslog Server
$progDownload = "visualsyslog_setup.zip"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Visual Syslog Server ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest https://github.com/MaxBelkov/visualsyslog/releases/download/v1.6.4/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    # https://drive.google.com/file/d/1DVVacvTssIfQnM9bsqap1XbegcEplW69/view?usp=sharing
    # Invoke-WebRequest "https://drive.google.com/uc?id=1DVVacvTssIfQnM9bsqap1XbegcEplW69&export=download" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EaeJTpbNm4lMg6mp7zi6SP4ByFuzzofRnctJtpObUFifMQ?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Visual Syslog ya esta descargado" -ForegroundColor Yellow
}

# Instalación de Visual Syslog Server
Write-Host "Descomprimiendo Visual Syslog Server ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\VisualSyslog") { Remove-Item -Path "$DesktopFolder\VisualSyslog" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" e -o"$DesktopFolder\VisualSyslog" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga sysmonconfig-export.xml
if (!(Test-Path -Path "$DesktopFolder\Sysinternals\sysmonconfig-export-swift.xml")) {
    Write-Host "Descargando sysmonconfig SwiftOnSecurity ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest https://github.com/SwiftOnSecurity/sysmon-config/raw/master/sysmonconfig-export.xml -OutFile "$DesktopFolder\Sysinternals\sysmonconfig-export-swift.xml"
    # https://drive.google.com/file/d/1OFrDCr7nT-agY6Wd9VWA0q3u4qbH_pr4/view?usp=sharing
    # Invoke-WebRequest "https://drive.google.com/uc?id=1OFrDCr7nT-agY6Wd9VWA0q3u4qbH_pr4&export=download" -OutFile "$DesktopFolder\Sysinternals\sysmonconfig-export-swift.xml"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/ERkdSNrfHTtHh9S5tYOKMEsBIW7iSFv9rOxXElgyxAsfjQ?download=1" -OutFile "$DesktopFolder\Sysinternals\sysmonconfig-export-swift.xml"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "sysmonconfig SwiftOnSecurity ya esta descargado" -ForegroundColor Yellow
}

# Descarga sysmonconfig-export.xml
if (!(Test-Path -Path "$DesktopFolder\Sysinternals\sysmonconfig-export-ion.xml")) {
    Write-Host "Descargando sysmonconfig Ion-Storm ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest https://github.com/ion-storm/sysmon-config/raw/master/sysmonconfig-export.xml -OutFile "$DesktopFolder\Sysinternals\sysmonconfig-export-ion.xml"
    # https://drive.google.com/file/d/1SU9wyYIaWab436COcKjI_fdKEUNnE3EA/view?usp=sharing
    # Invoke-WebRequest "https://drive.google.com/uc?id=1SU9wyYIaWab436COcKjI_fdKEUNnE3EA&export=download" -OutFile "$DesktopFolder\Sysinternals\sysmonconfig-export-ion.xml"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/Ea2Zj_6xhW1Nm-US0xrEYr8BZiQ8BhfbeiyGivVAM-vNLA?download=1" -OutFile "$DesktopFolder\Sysinternals\sysmonconfig-export-ion.xml"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "sysmonconfig Ion-Storm ya esta descargado" -ForegroundColor Yellow
}

# Descarga sysmonconfig-export.xml
if (!(Test-Path -Path "$DesktopFolder\Sysinternals\sysmonconfig-export-olaf.xml")) {
    Write-Host "Descargando sysmonconfig Olaf Hartong ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml -OutFile "$DesktopFolder\Sysinternals\sysmonconfig-export-olaf.xml"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/ES83WRVSPCpKhfn2BcREZXYBKpWcQzD3s_-aoc3aXncH1w?download=1" -OutFile "$DesktopFolder\Sysinternals\sysmonconfig-export-olaf.xml"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "sysmonconfig Olaf Hartong ya esta descargado" -ForegroundColor Yellow
}

# Descarga scripts del Máster
if (Test-Path -Path "$DesktopFolder\Scripts") {
    Remove-Item "$DesktopFolder\Scripts" -Recurse -Force | Out-Null
}
mkdir "$DesktopFolder\Scripts" -Force | Out-Null
& "$DesktopFolder\Git\bin\git.exe" clone https://github.com/manelrodero/Master-UPC-School.git "$DesktopFolder\Scripts"

# Creación carpeta C:\TEST
if (!(Test-Path -Path "C:\TEST")) { mkdir "C:\TEST" | Out-Null }

# Descarga OSSEC
$progDownload = "ossec-agent-win32-3.3.0-7006.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando OSSEC ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    # Invoke-WebRequest https://updates.atomicorp.com/channels/atomic/windows/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    # https://drive.google.com/file/d/1mXAfYBZuNvXTAMXO2yov4D61ctb2D5Di/view?usp=sharing
    # Invoke-WebRequest "https://drive.google.com/uc?id=1mXAfYBZuNvXTAMXO2yov4D61ctb2D5Di&export=download" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EYCpoIMgIglNoK0YT27IxLcBbpbNnPbkfjmWh0mWLjTGSg?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "OSSEC ya esta descargado" -ForegroundColor Yellow
}

<#
# Descarga Maltego
$progDownload = "MaltegoSetup.v4.1.13.11516.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Maltego ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://www.paterva.com/malv41/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Maltego ya esta descargado" -ForegroundColor Yellow
}

# Descarga Shodan Entities
$progDownload = "shodan-maltego-entities.mtz"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Shodan Entities ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://static.shodan.io/downloads/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Shodan Entities ya esta descargado" -ForegroundColor Yellow
}

# Descarga Java
$progDownload = "jre-8u191-windows-i586.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando JRE ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://javadl.oracle.com/webapps/download/AutoDL?BundleId=235725_2787e4a523244c269598db4e85c51e0c -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "JRE ya esta descargado" -ForegroundColor Yellow
}
#>

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
$progDownload = "VBoxWindowsAdditions-x86.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando VirtualBox GA x86 ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EbUzzIFqVI5MkGCvgnfZRCYBD2u370r8LH3BuOyW6LUXRQ?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "VirtualBox GA x86 ya esta descargado" -ForegroundColor Yellow
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

# Descarga Microsoft Edge
$progDownload = "MicrosoftEdgeEnterpriseX86.msi"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Microsoft Edge ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EZy21lOwcfBKpUvedEHBmUMBti4DVXQ4nl6AE4XNOZU4eg?download=1" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Microsoft Edge ya estaba descargado" -ForegroundColor Yellow
}

# Configuración de IP estática
Write-Host "Configurando Static IP ... " -ForegroundColor Green -NoNewline
netsh.exe interface ipv4 set address "Ethernet 3" static 10.0.20.81 255.255.255.0 10.0.20.1
Start-Sleep 5
netsh.exe interface ipv4 set dnsservers "Ethernet 3" static address=10.0.20.1 register=none
Start-Sleep 5
netsh.exe interface ipv4 set address "Ethernet 2" static 192.168.56.81 255.255.255.0
Write-Host "OK" -ForegroundColor Yellow

# Creación de usuarios 'testX'
Write-Host "Creando usuario 'test1' ... " -ForegroundColor Green -NoNewline
net.exe user test1 /add Passw0rd! >$null
Write-Host "Creando usuario 'test2' ... " -ForegroundColor Green -NoNewline
net.exe user test2 /add Passw0rd! >$null
Write-Host "Creando usuario 'test3' ... " -ForegroundColor Green -NoNewline
net.exe user test3 /add Passw0rd! >$null

# Final del script (evitar que se cierre)
Write-Host "Pulsa una tecla para apagar el equipo ..."
$tecla = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Stop-Computer -Force
