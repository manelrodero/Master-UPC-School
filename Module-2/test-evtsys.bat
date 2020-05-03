@echo off

echo Test Event to Syslog

cd "%userprofile%\Desktop\MASTER\EventSyslog"
echo Instalando evtsys -i -a -h 192.168.56.16 -f daemon -l 3 -p 514...
evtsys -i -a -h 192.168.56.16 -f daemon -l 3 -p 514
net start evtsys
eventcreate /t warning /id 1000 /l Application /D "Prueba desde Windows (evtsys)"
