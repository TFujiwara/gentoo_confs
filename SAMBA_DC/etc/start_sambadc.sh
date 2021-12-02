#!/bin/bash
test -d /run/samba || mkdir -p /run/samba
test -d /var/log/samba || mkdir -p /var/log/samba
/usr/sbin/samba
if [ $? -eq 0 ]; then
echo "Se ha iniciado SAMBA correctamente."
else
    "Samba no se ha iniciado correctamente. Verifica el log para ver el error ocasionado."
fi
