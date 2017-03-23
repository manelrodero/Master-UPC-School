@echo off
setlocal

set VBoxManage=C:\Program Files\Oracle\VirtualBox\VBoxManage.exe

if exist "%VBoxManage%" (
	"%VBoxManage%" dhcpserver remove -netname "NatVBox" >nul 2>&1
	"%VBoxManage%" natnetwork stop --netname "NatVBox"
	"%VBoxManage%" natnetwork remove --netname NatVBox >nul 2>&1

	"%VBoxManage%" natnetwork add --netname NatVBox --network "10.0.20.0/24" --enable --dhcp on
	"%VBoxManage%" natnetwork start --netname NatVBox
	"%VBoxManage%" dhcpserver modify --netname NatVBox --ip 10.0.20.3 --netmask 255.255.255.0 --lowerip 10.0.20.128 --upperip 10.0.20.254

	"%VBoxManage%" list natnets
	"%VBoxManage%" list dhcpservers
) else (
	echo No se ha encontrado "%VBoxManage%"
)

endlocal
