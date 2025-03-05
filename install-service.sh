#!/bin/bash

if [ "$EUID" -ne 0 ]; then
   echo "Este script requiere permisos de root."
   exit
fi

# set pwd to current directory
cd "$(dirname "$0")"

#limpia el contenido del directorio de trabajo
rm -rf /app*
rm -rf /srv/*

# Configura un directorio `/app` como buffer de video
sed -i -e '/srv/d' /etc/fstab
sed -i -e '$a/tmpfs  /app  tmpfs  rw,nosuid,nodev,size=32m   0  0' /etc/fstab

# Crea directorio donde se almacena el buffer de video
mkdir /app

# Desocupa el tercer procesador para ser usado exclusivamente por el sub-proceso de renderizado
sed -i -e 's/ isocpus=3//g' /boot/cmdline.txt
sed -i -e 's/$/ isocpus=3/' /boot/cmdline.txt

#copia la biblioteca al directorio de trabajo
cp -R rgbmatrix /srv/rgbmatrix

#copia el sub-sistema de renderizado
mkdir /app
cp -rf init.png /srv
cp -rf led-driver.py /app/
chmod +x /app/led-driver.py  

#Crea el servicio
cp -rf led-driver.service /etc/systemd/system/led-driver.service

# Recarga e inicia automaticamente al prender.
systemctl daemon-reload
systemctl unmask led-driver.service
systemctl enable led-driver.service

# Mensaje de salida
echo "Debe reiniciar la Raspberry para que el servicio pueda iniciarse"
echo "Luego, cualquier cambio en la web se reflejará automáticamente en los paneles LED."
