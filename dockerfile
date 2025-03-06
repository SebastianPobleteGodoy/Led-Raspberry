# Usa una imagen base optimizada para Raspberry Pi
FROM balenalib/raspberrypi3-debian:latest

# Variables de entorno para evitar prompts
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    python3 python3-dev python3-pip \
    build-essential cmake git \
    swig \
    python3-pillow libgraphicsmagick++-dev \
    libwebp-dev libjpeg-dev libpng-dev libtiff5-dev libfreetype6-dev \
    chromium-browser scrot \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# (Opcional) Asegurar que pip, setuptools y wheel estén actualizados
RUN pip3 install --upgrade pip setuptools wheel

# Copiar la carpeta rpi-rgb-led-matrix completa al contenedor
COPY rpi-rgb-led-matrix /app/rpi-rgb-led-matrix

# Compilar la librería C++ y luego instalar los bindings de Python
RUN cd /app/rpi-rgb-led-matrix && \
    make clean && make -j4 && \
    cd bindings/python && \
    # Compilar e instalar los bindings de Python
    python3 setup.py install

# Copiar los archivos principales de tu aplicación
COPY autorun.sh /app/autorun.sh
COPY led-driver.py /app/led-driver.py
COPY init.png /app/init.png

# Otorgar permisos de ejecución
RUN chmod +x /app/autorun.sh /app/led-driver.py

# Comando de inicio: ejecuta autorun.sh
CMD ["/bin/bash", "/app/autorun.sh"]
