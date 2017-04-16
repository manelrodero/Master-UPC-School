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
	res=$(sudo apt-get install -qy $1)
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
		rm -rf $1
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

# Instalación de ethtool para desactivar GRO/LRO
installPackage ethtool
sudo ethtool -K eth0 gro off
sudo ethtool -K eth1 gro off
#sudo ethtool -K eth0 lro off
#sudo ethtool -K eth1 lro off

# Instalación de las herramientas de compilación y Git
installPackage build-essential
installPackage git

# Instalación de los pre-requisitos de Snort
installPackage libpcap-dev
installPackage libpcre3-dev
installPackage libdumbnet-dev

# Creación directorio para descargar los paquetes
createDirNew ~/snort_src

# Descarga de DAQ
cd  ~/snort_src
if [ ! -f daq-2.0.6.tar.gz ]; then
	downloadFile daq-2.0.6.tar.gz https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz
fi

# Instalación de los pre-requisitos de DAQ
installPackage bison
installPackage flex

# Instalación de DAQ
cd  ~/snort_src
echo -ne "- ${BOLD}Compilando ${BLUE}DAQ 2.0.6${NOCOLOR} [~30seg]... "
tar -zxvf daq-2.0.6.tar.gz >/dev/null 2>&1
cd daq-2.0.6
./configure >/dev/null 2>&1
make >/dev/null 2>&1
sudo make install >/dev/null 2>&1
echo -ne "${GREEN}OK${NOCOLOR}\n"

# Descarga de Snort
cd ~/snort_src
if [ ! -f snort-2.9.9.0.tar.gz ]; then
	downloadFile snort-2.9.9.0.tar.gz https://www.snort.org/downloads/snort/snort-2.9.9.0.tar.gz
fi

# Instalación de los pre-requisitos de Snort
installPackage zlib1g-dev
installPackage liblzma-dev
installPackage openssl
installPackage libssl-dev

# Instalación de Snort
cd  ~/snort_src
echo -ne "- ${BOLD}Compilando ${BLUE}Snort 2.9.9.0${NOCOLOR} [~120seg]... "
tar -zxvf snort-2.9.9.0.tar.gz >/dev/null 2>&1
cd snort-2.9.9.0
./configure --enable-sourcefire >/dev/null 2>&1
make >/dev/null 2>&1
sudo make install >/dev/null 2>&1
echo -ne "${GREEN}OK${NOCOLOR}\n"

# Actualización de librerías
sudo ldconfig

# Creación de enlace simbólico
if [ -f /usr/sbin/snort ]; then
	sudo rm /usr/sbin/snort
fi
sudo ln -s /usr/local/bin/snort /usr/sbin/snort

# Test Snort
checkCommand snort
snort -V

# Crear el usuario y grupo snort
echo -ne "- ${BOLD}Creando usuario ${BLUE}snort:snort${NOCOLOR}... "
sudo groupadd snort >/dev/null 2>&1
sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort >/dev/null 2>&1
echo -ne "${GREEN}OK${NOCOLOR}\n"

# Crear los directorios de Snort
echo -ne "- ${BOLD}Creando directorios en /etc/snort${NOCOLOR}... "
createDirSudo /etc/snort 
createDirSudo /etc/snort/rules
createDirSudo /etc/snort/rules/iplists
createDirSudo /etc/snort/preproc_rules
createDirSudo /etc/snort/so_rules
createDirSudo /usr/local/lib/snort_dynamicrules
createDirSudo /var/log/snort
createDirSudo /var/log/snort/archived_logs
echo -ne "${GREEN}OK${NOCOLOR}\n"

# Crear algunos ficheros de reglas y listas de IPs
echo -ne "- ${BOLD}Creando ficheros configuración${NOCOLOR}... "
createFileSudo /etc/snort/rules/iplists/black_list.rules
createFileSudo /etc/snort/rules/iplists/white_list.rules
createFileSudo /etc/snort/rules/local.rules
createFileSudo /etc/snort/sid-msg.map
echo -ne "${GREEN}OK${NOCOLOR}\n"

# Ajustar permisos
echo -ne "- ${BOLD}Cambiando permisos directorios${NOCOLOR}... "
sudo chmod -R 5775 /etc/snort
sudo chmod -R 5775 /etc/snort/so_rules
sudo chmod -R 5775 /usr/local/lib/snort_dynamicrules
sudo chmod -R 5775 /var/log/snort
sudo chmod -R 5775 /var/log/snort/archived_logs
echo -ne "${GREEN}OK${NOCOLOR}\n"

# Cambiar propietarios
echo -ne "- ${BOLD}Cambiando propietario directorios${NOCOLOR}... "
sudo chown -R snort:snort /etc/snort
sudo chown -R snort:snort /var/log/snort
sudo chown -R snort:snort /usr/local/lib/snort_dynamicrules
echo -ne "${GREEN}OK${NOCOLOR}\n"

# Copiar ficheros de configuración
echo -ne "- ${BOLD}Copiando ficheros configuración${NOCOLOR}... "
sudo cp ~/snort_src/snort-2.9.9.0/etc/*.conf* /etc/snort
sudo cp ~/snort_src/snort-2.9.9.0/etc/*.map /etc/snort
sudo cp ~/snort_src/snort-2.9.9.0/etc/*.dtd /etc/snort
sudo cp ~/snort_src/snort-2.9.9.0/src/dynamic-preprocessors/build/usr/local/lib/snort_dynamicpreprocessor/* /usr/local/lib/snort_dynamicpreprocessor/
echo -ne "${GREEN}OK${NOCOLOR}\n"

# Descargar Snort rules
cd ~/snort_src
createDir rules

downloadFile community-rules.tar.gz https://www.snort.org/downloads/community/community-rules.tar.gz
downloadFile emerging.rules.tar.gz http://rules.emergingthreats.net/open/snort-2.9.0/emerging.rules.tar.gz
tar -zxvf community-rules.tar.gz -C ./rules/ >/dev/null 2>&1
tar -zxvf emerging.rules.tar.gz -C ./rules/ >/dev/null 2>&1

# Requisitos de Pulled Pork
installPackage libcrypt-ssleay-perl
installPackage liblwp-useragent-determined-perl

# Descarga e instalación de Pulled Pork
cd ~/snort_src
echo -ne "- ${BOLD}Clonando ${BLUE}pulledpork.pl${NOCOLOR}... "
git clone https://github.com/shirkdog/pulledpork.git >/dev/null 2>&1
if [ ! -d pulledpork ]; then
	echo -ne "${RED}Error!${NOCOLOR}\n"
	exit 1
else
	echo -ne "${GREEN}Correcto${NOCOLOR}\n"
fi
cd pulledpork
sudo cp pulledpork.pl /usr/local/bin
sudo chmod +x /usr/local/bin/pulledpork.pl
sudo cp etc/*.conf /etc/snort

# Test Snort
checkCommand pulledpork.pl
pulledpork.pl -V

# Comentar reglas para usar PulledPork
sudo sed -i 's/include \$RULE\_PATH/#include \$RULE\_PATH/' /etc/snort/snort.conf

# Descarga ficheros de configuración
downloadFile snort.conf https://github.com/manelrodero/Master-UPC-School/raw/master/Module-3/snort.conf
downloadFile pulledpork.conf https://github.com/manelrodero/Master-UPC-School/raw/master/Module-3/pulledpork.conf
sudo cp snort.conf /etc/snort
sudo cp pulledpork.conf /etc/snort

exit 0

