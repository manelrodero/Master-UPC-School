#!/bin/bash

# Demo de visualización de logs en Linux

# Visualizar un fichero de log (paginar mediante el comando 'more' o 'less')
cat /var/log/auth.log
echo ""
echo "- Visualiza un fichero de log mediante el comando 'cat'"
echo "  cat /var/log/auth.log"
read -p "Presione una tecla para continuar . . ."&&clear

# Mostrar las líneas que coinciden con un patrón (siguientes 9 con -A, anteriores con -B, cercanas con -C)
grep "session opened for user" /var/log/auth.log
echo ""
echo "- Búsqueda de un patrón mediante el comando 'grep'"
echo "  grep \"session opened for user\" /var/log/auth.log"
read -p "Presione una tecla para continuar . . ."&&clear

# Mostrar las primeras 10 líneas de un fichero
head -n 10 /var/log/bootstrap.log
echo ""
echo "- Muestra las primeras 10 líneas de un fichero mediante el comando 'head'"
echo "  head -n 10 /var/log/bootstrap.log"
read -p "Presione una tecla para continuar . . ."&&clear

# Mostrar las últimas 10 líneas de un fichero
tail -n 10 /var/log/bootstrap.log
echo ""
echo "- Muestra las últimas 10 líneas de un fichero mediante el comando 'tail'"
echo "  tail -n 10 /var/log/bootstrap.log"
read -p "Presione una tecla para continuar . . ."&&clear

# Ignorar las primeras 10 líneas de un fichero
tail -n +11 /var/log/bootstrap.log
echo ""
echo "- Ignora las primeras 10 líneas de un fichero mediante el comando 'tail'"
echo "  tail -n +11 /var/log/bootstrap.log"
read -p "Presione una tecla para continuar . . ."&&clear

# Buscar un patrón (y líneas cercanas) en un fichero comprimido
zcat /var/log/apt/history.log.1.gz | grep -C 2 "Commandline:"
echo ""
echo "- Busca un patrón en un fichero comprimido mediante el comando 'zcat'"
echo "  zcat /var/log/apt/history.log.1.gz | grep -C 2 \"Commandline:\""
read -p "Presione una tecla para continuar . . ."&&clear

# Visualiza un fichero numerando las líneas
cat -n /var/log/bootstrap.log
echo ""
echo "- Visualiza un fichero numerando las líneas"
echo "  cat -n /var/log/bootstrap.log"
read -p "Presione una tecla para continuar . . ."&&clear
