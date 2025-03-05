#!/bin/bash

# Inicia Chromium en modo kiosk con la página web
chromium-browser --kiosk --disable-infobars --disable-session-crashed-bubble https://citylabbiobio.cl/visor/visor/ &

# Espera 5 segundos para asegurar que el navegador se abre completamente
sleep 5

# Ejecuta el script de renderizado en la matriz LED
sudo python3 /srv/subsystem/led-driver.py
