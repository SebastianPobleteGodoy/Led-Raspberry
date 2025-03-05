#!/usr/bin/env python
import time
import os
import subprocess
from rgbmatrix import RGBMatrix, RGBMatrixOptions
from PIL import Image

# Configuration for the matrix
options = RGBMatrixOptions()
options.rows = 40
options.cols = 80
options.chain_length = 2
options.parallel = 1
options.gpio_slowdown = 4
#options.row_address_type = 0

matrix = RGBMatrix(options=options)

# Ruta del buffer de imagen
img_path = "/srv/ledram/current.png"

# 🔹 Inicia Chromium en modo kiosk para mostrar la web
subprocess.Popen(["chromium-browser","--no-sandbox",  "--kiosk", "--disable-infobars",
                  "--disable-session-crashed-bubble", "https://citylabbiobio.cl/visor/visor/"])

# 🔹 Captura la pantalla y la actualiza en los paneles LED en un bucle infinito
while True:
    subprocess.run(["scrot", img_path])  # Captura la pantalla completa y la guarda en /srv/ledram/current.png
    image = Image.open(img_path).convert('RGB')
    matrix.SetImage(image)
    time.sleep(0.1)  # 🔹 Reduce este tiempo si quieres una actualización más rápida
