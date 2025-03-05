# Usa una imagen base optimizada para Raspberry Pi
FROM balenalib/raspberrypi3-debian:latest

# Configurar el directorio de trabajo dentro del contenedor
WORKDIR /app

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    python3 python3-dev python3-pip \
    build-essential cmake git \
    python3-pillow libgraphicsmagick++-dev \
    libwebp-dev libjpeg-dev libpng-dev libtiff5-dev libfreetype6-dev \
    chromium-browser scrot \
    && rm -rf /var/lib/apt/lists/*

# Clonar y compilar rpi-rgb-led-matrix dentro del contenedor
RUN git clone --recursive https://github.com/hzeller/rpi-rgb-led-matrix.git /app/rpi-rgb-led-matrix && \
    cd /app/rpi-rgb-led-matrix && \
    make -j4 && \
    sudo make install && \
    cd bindings/python && \
    python3 setup.py install
    
RUN apt-get update && apt-get install -y lsb-release
RUN apt-get update && apt-get install -y scrot


# Copiar los archivos del proyecto
COPY led-driver.py /srv/subsystem/led-driver.py
COPY led-driver.py /app/led-driver.py
COPY autorun.sh /app/autorun.sh
COPY init.png /app/init.png

# Dar permisos de ejecución
RUN chmod +x /app/autorun.sh /app/led-driver.py

# Definir el comando de inicio
CMD ["/bin/bash", "/app/autorun.sh"]
