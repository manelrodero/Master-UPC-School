#!/bin/bash

# Script de configuración de red NatVBox en Oracle VM VirtualBox para Mac OS X

/Applications/VirtualBox.app/Contents/MacOS/VBoxManage natnetwork add --netname NatVBox --network "10.0.20.0/24" --enable --dhcp on

/Applications/VirtualBox.app/Contents/MacOS/VBoxManage natnetwork start --netname NatVBox

/Applications/VirtualBox.app/Contents/MacOS/VBoxManage dhcpserver modify --netname NatVBox --ip 10.0.20.3 --netmask 255.255.255.0 --lowerip 10.0.20.128 --upperip 10.0.20.254
