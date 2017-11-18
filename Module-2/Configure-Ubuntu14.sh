#!/bin/bash

# Script de configuración de una máquina Ubuntu basado en el de Justin Rummel:
# https://github.com/justinrummel/Random-Scripts/blob/master/VMWare/ubuntuSetup.sh

# Base Variables that I use for all scripts.  Creates Log files and sets date/time info

declare -x SCRIPTPATH="${0}"
declare -x RUNDIRECTORY="${0%/*}"
declare -x SCRIPTNAME="${0##*/}"

logtag="${0##*/}"
debug_log="enable"
logDate=`date "+%Y-%m-%d"`
logDateTime=`date "+%Y-%m-%d_%H:%M:%S"`
log_dir="/var/log/${logtag}"
LogFile="${logtag}-${logDate}.log"

# Script Variables

# Script Functions

verifyRoot () {
	# Make sure we are root before proceeding
	[ `id -u` != 0 ] && { echo "$0: Please run this as root (using sudo)."; exit 0; }
}

logThis () {
	# Output to stdout and LogFile
	logger -s -t "${logtag}" "$1"
	[ "${debug_log}" == "enable" ] && { echo "${logDateTime}: ${1}" >> "${log_dir}/${LogFile}"; }
}

init () {
	# Make our log directory
	[ ! -d $log_dir ] && { mkdir $log_dir; }
	
	# Now make our log file
	if [ -d $log_dir ]; then
		[ ! -e "${log_dir}/${LogFile}" ] && { touch $log_dir/${LogFile}; logThis "Log file ${LogFile} created"; logThis "Date: ${logDateTime}"; }
	else
		echo "Error: Could not create log file in directory $log_dir."
		exit 1
	fi
	echo " " >> "${log_dir}/${LogFile}"
}

update() {
	logThis "Running apt-get update."
	getUpdates=$(sudo /usr/bin/apt-get -qy update > /dev/null)
	[ $? != 0 ] && { logThis "apt-get update had an error.  Stopping now!"; exit 1; } || { logThis "apt-get update completed successfully."; }
}

sshServer() {
	sshCheck=$(netstat -natp | grep [s]shd | grep LISTEN | grep -v tcp6)
	[ $? != 0 ] && { logThis "openssh-server is NOT installed."; installOpenssh; } || { logThis "openssh-server is running."; }
}

installOpenssh() {
	logThis "Installing openssh-server."
	installSSH=$(sudo /usr/bin/apt-get install openssh-server -qy)
	[ $? != 0 ] && { logThis "apt-get install openssh-server had an error.  Stopping now!"; exit 1; } || { logThis "apt-get install openssh-server completed successfully."; }
}

gitCLI() {
	gitCheck=$(which git)
	[ $? != 0 ] && { logThis "git is NOT installed."; installGit; } || { logThis "git is available."; }
}

installGit() {
	logThis "Installing git."
	installGit=$(sudo /usr/bin/apt-get install git -qy)
	[ $? != 0 ] && { logThis "apt-get install git had an error.  Stopping now!"; exit 1; } || { logThis "apt-get install git completed successfully."; }
}

verifyRoot
init
update
gitCLI
sshServer

exit 0
