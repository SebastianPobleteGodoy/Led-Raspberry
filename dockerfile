# Imagen base para Raspberry Pi
FROM balenalib/raspberrypi3-debian:latest

# Definir el directorio de trabajo dentro del contenedor
WORKDIR /app

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    python3-pil \
    scrot \
    chromium-browser \
    && rm -rf /var/lib/apt/lists/*

# Copiar archivos al contenedor
COPY led-driver.py /app/led-driver.py
COPY autorun.sh /app/autorun.sh
COPY init.png /app/init.png

# Dar permisos de ejecución
RUN chmod +x /app/autorun.sh /app/led-driver.py

# Definir el comando de inicio
CMD ["/bin/bash", "/app/autorun.sh"]
