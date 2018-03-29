#Requires -RunAsAdministrator

$ip = Get-NetIPAddress | Where-Object {$_.IPAddress -like '192.168.56.*'}
if ($ip) {
    New-NetIPAddress -InterfaceIndex $ip.InterfaceIndex -IPAddress 192.168.56.8 -PrefixLength 24
    Set-DnsClient -RegisterThisConnectionsAddress:$false -InterfaceIndex $ip.InterfaceIndex
    Rename-NetAdapter -Name $ip.InterfaceAlias -NewName "HostOnly"
} else {
    Write-Host "No hay interfaz en red 192.168.56.0/24"
}

$ip = Get-NetIPAddress | Where-Object {$_.IPAddress -like '10.0.20.*'}
if ($ip) {
    $gw = (Get-NetIPConfiguration -InterfaceIndex $ip.InterfaceIndex).IPv4DefaultGateway.NextHop
    $dns = (Get-DnsClientServerAddress -InterfaceIndex $ip.InterfaceIndex -AddressFamily IPv4).ServerAddresses
    New-NetIPAddress -InterfaceIndex $ip.InterfaceIndex -IPAddress 10.0.20.8 -PrefixLength 24 -DefaultGateway $gw
    Set-DnsClientServerAddress -InterfaceIndex $ip.InterfaceIndex -ServerAddresses $dns
    Set-DnsClient -RegisterThisConnectionsAddress:$false -InterfaceIndex $ip.InterfaceIndex
    Rename-NetAdapter -Name $ip.InterfaceAlias -NewName "NatVBox"
} else {
    Write-Host "No hay interfaz en red 10.0.20.0/24"
}

$nic = Get-WmiObject Win32_NetworkAdapterConfiguration -filter "ipenabled = 'true'"
if ($nic) {
    $nic.SetTcpipNetbios(2) >$null
}

reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v "Bginfo.exe" /t "REG_SZ" /d "c:\wallpaper\Bginfo.exe c:\wallpaper\bgconfig.bgi /timer:0" /f >$null

Rename-Computer -NewName "win81client" -Restart
