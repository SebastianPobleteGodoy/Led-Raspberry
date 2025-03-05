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

echo -n "Instalando librerias necesarias "
sudo apt update > /dev/null 2>&1 
sudo apt-get install python3-dev python3-pillow -y > /dev/null 2>&1 

# Verificar el código de retorno llamando a la función
verificar_codigo_retorno $?

echo -n "Entrando al repositorio "
# Pedir al usuario que ingrese un valor
echo "Usuario:"
read valor
cd rpi-rgb-led-matrix/bindings/python 

# Verificar el código de retorno llamando a la función
verificar_codigo_retorno $?

echo -n "Instalando rpi-rgb-led-matrix "
make build-python PYTHON=$(command -v python3) > /dev/null 2>&1 
sudo make install-python PYTHON=$(command -v python3) > /dev/null 2>&1 

# Verificar el código de retorno llamando a la función
verificar_codigo_retorno $?


echo -n "Instalando docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh > /dev/null 2>&1 

verificar_codigo_retorno $?


