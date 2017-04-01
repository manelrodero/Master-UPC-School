@echo off

if [%1]==[] goto :eof

echo Test Event to Syslog

cd "%userprofile%\Desktop\MASTER\EventSyslog"
echo Instalando evtsys -i -a -h %1 -f daemon -l 3 -p 514...
evtsys -i -a -h %1 -f daemon -l 3 -p 514
net start evtsys
eventcreate /t warning /id 1000 /l Application /D "Prueba"
