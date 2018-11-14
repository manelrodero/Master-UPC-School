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

# Descarga LGPO 2.2
$progDownload = "LGPO.zip"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando LGPO ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
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
$progDownload = "PortableGit-2.16.2-32-bit.7z.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Git-Portable ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.16.2.windows.1/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
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

# Descarga Notepad++
$progDownload = "npp.7.5.1.bin.7z"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Notepad++ ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://notepad-plus-plus.org/repository/7.x/7.5.1/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
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
& "$env:ProgramFiles\7-Zip\7z.exe" x -o"$DesktopFolder\Hstart" -y "$DesktopFolder\Downloads\$progDownload" "hstart.exe" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga Logger
$progDownload = "logger.zip"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Logger ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest http://www.monitorware.com/en/logger/download.asp -OutFile "$DesktopFolder\Downloads\$progDownload"
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
    Invoke-WebRequest https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/eventlog-to-syslog/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Event to Syslog ya esta descargado" -ForegroundColor Yellow
}

# Instalación de Event to Syslog
Write-Host "Descomprimiendo Event to Syslog ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\EventSyslog") { Remove-Item -Path "$DesktopFolder\EventSyslog" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" e -o"$DesktopFolder\EventSyslog" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga NXLog-CE
$progDownload = "nxlog-ce-2.10.2102.msi"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando NXLog-CE ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://nxlog.co/system/files/products/files/348/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "NXLog-CE ya esta descargado" -ForegroundColor Yellow
}

# Descarga Visual Syslog Server
$progDownload = "visualsyslog_setup.zip"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Visual Syslog Server ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://github.com/MaxBelkov/visualsyslog/releases/download/v1.6.4/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
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
    Invoke-WebRequest https://github.com/SwiftOnSecurity/sysmon-config/raw/master/sysmonconfig-export.xml -OutFile "$DesktopFolder\Sysinternals\sysmonconfig-export-swift.xml"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "sysmonconfig SwiftOnSecurity ya esta descargado" -ForegroundColor Yellow
}

# Descarga sysmonconfig-export.xml
if (!(Test-Path -Path "$DesktopFolder\Sysinternals\sysmonconfig-export-ion.xml")) {
    Write-Host "Descargando sysmonconfig Ion-Storm ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://github.com/ion-storm/sysmon-config/raw/master/sysmonconfig-export.xml -OutFile "$DesktopFolder\Sysinternals\sysmonconfig-export-ion.xml"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "sysmonconfig Ion-Storm ya esta descargado" -ForegroundColor Yellow
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
$progDownload = "ossec-agent-win32-2.8.3.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando OSSEC ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://bintray.com/artifact/download/ossec/ossec-hids/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "OSSEC ya esta descargado" -ForegroundColor Yellow
}

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

# Final del script (evitar que se cierre)
Write-Host "Pulsa una tecla para reiniciar el equipo ..."
$tecla = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Restart-Computer -Force
