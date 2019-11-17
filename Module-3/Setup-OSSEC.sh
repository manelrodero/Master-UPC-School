#!/bin/bash

# Script de instalación de Snort basado en la guía "Snort 2.9.8.x on Ubuntu 12, 14, and 15" de Noah Dietrich
# https://github.com/bensooter/SnortOnUbuntu

# Descarga de ficheros desde Google Drive personal
# http://goo.gl/FK4Wkn

RED='\033[0;31m'
ORANGE='\033[0;205m'
YELLOW='\033[0;93m'
GREEN='\033[0;32m'
CYAN='\033[0;96m'
BLUE='\033[0;34m'
VIOLET='\033[0;35m'
NOCOLOR='\033[0m'
BOLD='\033[1m'

installPackage() {
	echo -ne "- ${BOLD}Instalando ${YELLOW}$1${NOCOLOR}... "
	res=$(sudo apt-get install -qy $1)
	[ $? != 0 ] && { echo -ne "${RED}Error!${NOCOLOR}\n"; exit 1; } || { echo -ne "${GREEN}Correcto${NOCOLOR}\n"; }
}

downloadFile() {
	echo -ne "- ${BOLD}Descargando ${YELLOW}$1${NOCOLOR}... "
	res=$(wget -O $1 $2 >/dev/null 2>&1)
	[ $? != 0 ] && { echo -ne "${RED}Error!${NOCOLOR}\n"; exit 1; } || { echo -ne "${GREEN}Correcto${NOCOLOR}\n"; }
}

checkCommand() {
	echo -ne "- ${BOLD}Comprobando '${YELLOW}$1${NOCOLOR}${BOLD}'${NOCOLOR}... "
	gitCheck=$(which $1)
	[ $? != 0 ] && { echo -ne "${RED}No existe!${NOCOLOR}\n"; exit 1; } || { echo -ne "${GREEN}Disponible${NOCOLOR}\n"; }
}

createDir() {
	if [ ! -d $1 ]; then
		mkdir $1
	fi
}

createDirNew() {
	if [ -d $1 ]; then
		sudo rm -rf $1
	fi
	mkdir $1
}

createDirSudo() {
	if [ ! -d $1 ]; then
		sudo mkdir $1
	fi
}

createFileSudo() {
	if [ ! -f $1 ]; then
		sudo touch $1
	fi
}

# Instalación de OpenSSH para administrar el equipo remotamente
installPackage openssh-server

# Instalación de librerías adicionales para OSSEC 3.3.0 (https://github.com/ossec/ossec-hids/issues/1663)
installPackage libpcre2-dev
installPackage zlib1g-dev

# Instalación de las herramientas de compilación y Git
installPackage build-essential
installPackage libz-dev
installPackage git

# Por si estuviera en marcha
sudo /var/ossec/bin/ossec-control stop >/dev/null 2>&1

# Creación directorio para descargar los paquetes
createDirNew ~/ossec_src

# Descarga de OSSEC
cd  ~/ossec_src
if [ ! -f ossec-hids-3.3.0.tar.gz ]; then
	# OSSEC 3.3.0 (https://github.com/ossec/ossec-hids/archive/3.3.0.tar.gz)
	downloadFile ossec-hids-3.3.0.tar.gz "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EcyOsaHyaOBPlAfhh2-_eUABSAu46XpyrkTSTZkX_YAdFw?download=1"
fi

# Instalación de OSSEC
cd  ~/ossec_src
echo -ne "- ${BOLD}Descomprimiendo ${YELLOW}OSSEC 3.3.0${NOCOLOR}... "
tar -zxvf ossec-hids-3.3.0.tar.gz >/dev/null 2>&1
echo -ne "${GREEN}OK${NOCOLOR}\n"

# Descarga ficheros de configuración
downloadFile preloaded-vars.conf https://github.com/manelrodero/Master-UPC-School/raw/master/Module-3/preloaded-vars.conf
cp preloaded-vars.conf ossec-hids-3.3.0/etc

# Configuración desatendida
echo -ne "- ${BOLD}Compilando/Configurando ${YELLOW}OSSEC 3.3.0${NOCOLOR} [~30seg]... "
cd ossec-hids-3.3.0
sudo PCRE2_SYSTEM=yes ./install.sh >/dev/null 2>&1
echo -ne "${GREEN}OK${NOCOLOR}\n"

echo -ne "- ${BOLD}Parando OSSEC${NOCOLOR}... "
sudo /var/ossec/bin/ossec-control stop >/dev/null 2>&1
echo -ne "${GREEN}OK${NOCOLOR}\n"

# Instalación de Apache para OSSEC Web UI
installPackage apache2
installPackage apache2-utils

# Instalación del soporte para PHP (PHP7)
installPackage php
installPackage libapache2-mod-php

# Descarga de OSSEC Web UI
cd  ~/ossec_src
if [ ! -f ossec-wui-master.zip ]; then
	# OSSE-WUI (https://github.com/ossec/ossec-wui/archive/master.zip)
	downloadFile ossec-wui-master.zip "https://upc0-my.sharepoint.com/:u:/g/personal/manel_rodero_upc_edu/EeR1f6z_-tFBsfn-YgiESUABLTbTLXYztOiZh1G5GlEgQw?download=1"
fi

# Instalación de OSSEC Web UI
cd  ~/ossec_src
echo -ne "- ${BOLD}Descomprimiendo ${YELLOW}OSSEC Web UI 0.9+${NOCOLOR}... "
unzip ossec-wui-master.zip >/dev/null 2>&1
echo -ne "${GREEN}OK${NOCOLOR}\n"

sudo mv ossec-wui-master /var/www/html/ossec-wui/
cd /var/www/html/ossec-wui/
sudo ./setup.sh

# Descarga ficheros de configuración
downloadFile apache2.conf https://github.com/manelrodero/Master-UPC-School/raw/master/Module-3/apache2.conf
sudo cp apache2.conf /etc/apache2/apache2.conf

echo -ne "- ${BOLD}Reiniciando ${YELLOW}Apache${NOCOLOR}... "
sudo apache2ctl restart
echo -ne "${GREEN}OK${NOCOLOR}\n"