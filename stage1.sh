#!/bin/bash
# Script instalación Gentoo by Cristian Garcia Quevedo a.k.a TFujiwara
# Made from Whihax Security to the world...
# Ejecutar este script después del particionado del disco con fdisk o cfdisk, el que mas rabia os de.
dir="/mnt/gentoo"
dir2="/mnt/sys"
cores=$(cat /proc/cpuinfo | grep "cpu cores" | cut -c 13)
if [ -d "$dir" ]
then 
echo "El directorio donde está montado el disco del sistema existe, continuando..."
cd /mnt/gentoo
# Elegid de aqui el paquete de stage 3 que os interese, esto lo actualizare conforme cambien las versiones
# Stage 3 desktop sin hardenizar
# wget https://mirror.bytemark.co.uk/gentoo/releases/amd64/autobuilds/current-stage3-amd64-hardened-openrc/stage3-amd64-desktop-openrc-20211121T170545Z.tar.xz
# Stage 3 hardenizado
# wget https://mirror.bytemark.co.uk/gentoo/releases/amd64/autobuilds/current-stage3-amd64-hardened-openrc/stage3-amd64-hardened-openrc-20211121T170545Z.tar.xz
# Stage 3 hardenizado nomultilib
# wget https://mirror.bytemark.co.uk/gentoo/releases/amd64/autobuilds/current-stage3-amd64-hardened-openrc/stage3-amd64-hardened-nomultilib-openrc-20211121T170545Z.tar.xz
# Stage 3 hardenizado con SELinux
# wget https://mirror.bytemark.co.uk/gentoo/releases/amd64/autobuilds/current-stage3-amd64-hardened-openrc/stage3-amd64-hardened-selinux-openrc-20211121T170545Z.tar.xz
tar -xvf stage3-*.tar.xz
# Recordar al usuario la necesidad de configurar la flag USE si necesita algo más especifico que un sistema base sin X
echo "Te recuerdo que tienes que configurar la flag USE si necesitas algo más que un sistema base sin X (entorno gráfico), que es lo que se instala aqui. O puedes configurarlo posteriormente!"
echo "Cores a configurar en /etc/portage/make.conf: " $cores
# Parte de descarga de configuraciones/tweaks de gentoo desde el repo

# wget del make.conf en la carpeta /etc/portage del punto de montaje
# Descomentar una vez decidido que procesador estamos usando
# wget -O $dir/etc/portage/make.conf https://raw.githubusercontent.com/TFujiwara/gentoo_confs/main/<procesador>.conf

# Disparamos el editor nano en pantalla para que el usuario configure los cores y la flag USE en caso de necesitarlo
nano $dir/etc/portage/make.conf
# Copiamos el resolv.conf de la imagen LiveCD al sistema, advertimos que esto se puede modificar para poner los DNS que queramos
cp -L /etc/resolv.conf $dir/etc/resolv.conf
echo "Se ha copiado el resolv.conf del LiveCD que estes usando al sistema. Puedes modificarlo si crees conveniente para poner otros DNS."
# Montar los sistemas de archivos necesarios para compilar
mount -t proc none $dir/proc
mount --rbind /sys $dir/sys
mount --rbind /dev $dir/dev
# Creamos el directorio portage en /usr/
mkdir $dir/usr/portage
# Instalamos genfstab en el LiveCD de Gentoo y generamos fstab
emerge sys-fs/genfstab
genfstab -U -p $dir >> $dir/etc/fstab
# chroot al nuevo sistema (de forma temporal)
chroot $dir /bin/bash
else
if [ -d "$dir2"]
then
echo "El directorio donde está montado el disco del sistema existe, continuando..."
cd /mnt/sys
# Elegid de aqui el paquete de stage 3 que os interese, esto lo actualizare conforme cambien las versiones
# Stage 3 desktop sin hardenizar
# wget https://mirror.bytemark.co.uk/gentoo//releases/amd64/autobuilds/current-stage3-amd64-desktop-openrc/stage3-amd64-desktop-openrc-20211114T170549Z.tar.xz
# Stage 3 hardenizado
# wget https://mirror.bytemark.co.uk/gentoo//releases/amd64/autobuilds/current-stage3-amd64-desktop-openrc/stage3-amd64-hardened-openrc-20211114T170549Z.tar.xz
# Stage 3 hardenizado nomultilib
# wget https://mirror.bytemark.co.uk/gentoo//releases/amd64/autobuilds/current-stage3-amd64-desktop-openrc/stage3-amd64-hardened-nomultilib-openrc-20211114T170549Z.tar.xz
# Stage 3 hardenizado con SELinux
# https://mirror.bytemark.co.uk/gentoo//releases/amd64/autobuilds/current-stage3-amd64-desktop-openrc/stage3-amd64-hardened-selinux-openrc-20211114T170549Z.tar.xz
tar -xvf stage3-*.tar.xz
# Recordar al usuario la necesidad de configurar la flag USE si necesita algo más especifico que un sistema base sin X
echo "Te recuerdo que tienes que configurar la flag USE si necesitas algo más que un sistema base sin X (entorno gráfico), que es lo que se instala aqui. O puedes configurarlo posteriormente!"
echo "Cores a configurar en /etc/portage/make.conf: " $cores
# Parte de descarga de configuraciones/tweaks de gentoo desde el repo

# wget del make.conf en la carpeta /etc/portage del punto de montaje
# Descomentar una vez decidido que procesador estamos usando
# wget -O $dir2/etc/portage/make.conf https://raw.githubusercontent.com/TFujiwara/gentoo_confs/main/<procesador>.conf

# Disparamos el editor nano en pantalla para que el usuario configure los cores y la flag USE en caso de necesitarlo
nano $dir2/etc/portage/make.conf
# Copiamos el resolv.conf de la imagen LiveCD al sistema, advertimos que esto se puede modificar para poner los DNS que queramos
cp -L /etc/resolv.conf $dir2/etc/resolv.conf
echo "Se ha copiado el resolv.conf del LiveCD que estes usando al sistema. Puedes modificarlo si crees conveniente para poner otros DNS."
# Montar los sistemas de archivos necesarios para compilar
mount -t proc none $dir2/proc
mount --rbind /sys $dir2/sys
mount --rbind /dev $dir2/dev
# Creamos el directorio portage en /usr/
mkdir $dir2/usr/portage
# Instalamos genfstab en el LiveCD de Gentoo y generamos fstab
emerge sys-fs/genfstab
genfstab -U -p $dir2 >> $dir2/etc/fstab
# chroot al nuevo sistema (de forma temporal)
chroot $dir2 /bin/bash
else
echo "No se ha encontrado ningún directorio candidato a la instalación..."
exit 0 
fi
fi
