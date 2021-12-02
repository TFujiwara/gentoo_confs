#!/bin/bash
pkill samba
if [ $? -eq 0 ]; then
    echo "Samba se ha parado correctamente."
else
    echo "Algo ha fallado al parar samba..."
fi
