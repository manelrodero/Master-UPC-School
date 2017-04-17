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
	echo -ne "- ${BOLD}Instalando ${BLUE}$1${NOCOLOR}... "
	res=$(sudo apt-get install -qy $1 >/dev/null 2>&1)
	[ $? != 0 ] && { echo -ne "${RED}Error!${NOCOLOR}\n"; exit 1; } || { echo -ne "${GREEN}Correcto${NOCOLOR}\n"; }
}

downloadFile() {
	echo -ne "- ${BOLD}Descargando ${BLUE}$1${NOCOLOR}... "
	res=$(wget -O $1 $2 >/dev/null 2>&1)
	[ $? != 0 ] && { echo -ne "${RED}Error!${NOCOLOR}\n"; exit 1; } || { echo -ne "${GREEN}Correcto${NOCOLOR}\n"; }
}

checkCommand() {
	echo -ne "- ${BOLD}Comprobando '${BLUE}$1${NOCOLOR}${BOLD}'${NOCOLOR}... "
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

# Instalación de las herramientas de compilación y Git
installPackage build-essential
installPackage git

# Creación directorio para descargar los paquetes
createDirNew ~/ossec_src

# Descarga de OSSEC
cd  ~/ossec_src
if [ ! -f ossec-hids-2.8.3.tar.gz ]; then
	downloadFile ossec-hids-2.8.3.tar.gz https://bintray.com/artifact/download/ossec/ossec-hids/ossec-hids-2.8.3.tar.gz
fi

# Instalación de OSSEC
cd  ~/ossec_src
echo -ne "- ${BOLD}Descomprimiendo ${BLUE}OSSEC 2.8.3${NOCOLOR}... "
tar -zxvf ossec-hids-2.8.3.tar.gz >/dev/null 2>&1
echo -ne "${GREEN}OK${NOCOLOR}\n"

# Descarga ficheros de configuración
downloadFile preloaded-vars-agent.conf https://github.com/manelrodero/Master-UPC-School/raw/master/Module-3/preloaded-vars-agent.conf
cp preloaded-vars-agent.conf ossec-hids-2.8.3/etc/preloaded-vars.conf

# Configuración desatendida
echo -ne "- ${BOLD}Compilando/Configurando ${BLUE}OSSEC${NOCOLOR} [~30seg]... "
cd ossec-hids-2.8.3
sudo ./install.sh >/dev/null 2>&1
echo -ne "${GREEN}OK${NOCOLOR}\n"

echo -ne "- ${BOLD}Parando OSSEC${NOCOLOR}... "
sudo /var/ossec/bin/ossec-control stop >/dev/null 2>&1
echo -ne "${GREEN}OK${NOCOLOR}\n"

