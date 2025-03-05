#!/bin/bash

# Función para verificar el código de retorno
verificar_codigo_retorno() {
    if [ $1 -eq 0 ]; then
        echo "[OK]"
        # Agrega aquí el código para el siguiente paso
    else
        echo "Hubo un error en el comando. Abortando el script."
        exit 1  # Termina el script con un código de retorno no exitoso
    fi
}

# Instalación de bibliotecas
echo -n "Actualizando repositorios "
sudo apt update > /dev/null 2>&1 

# Verificar el código de retorno llamando a la función
verificar_codigo_retorno $?

echo -n "Instalando git "
sudo apt install git -y > /dev/null 2>&1 

# Verificar el código de retorno llamando a la función
verificar_codigo_retorno $?

echo -n "Clonando repo de la matriz led "
git clone https://github.com/hzeller/rpi-rgb-led-matrix.git > /dev/null 2>&1 

# Verificar el código de retorno llamando a la función
verificar_codigo_retorno $?

echo -n "Desactivando tarjeta de sonido "
cat <<EOF | sudo tee /etc/modprobe.d/blacklist-rgb-matrix.conf > /dev/null 2>&1
blacklist snd_bcm2835
EOF
sudo update-initramfs -u > /dev/null 2>&1

# Verificar el código de retorno llamando a la función
verificar_codigo_retorno $?

tiempo=5

echo "El equipo se apagará en: "
while [ $tiempo -gt 0 ]; do
    echo $tiempo
    sleep 1
    tiempo=$((tiempo-1))
done

echo "¡Apagando el equipo ahora!"
shutdown -h now
