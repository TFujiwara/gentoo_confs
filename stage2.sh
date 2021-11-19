#!/bin/bash
# Segunda parte de la instalacion
env-update
source /etc/profile
export PS1="(chroot) $PS1"
# Actualizar portage
emerge-webrsync
# Elegir perfil de instalación, descomentar esta linea una vez se tenga claro.
#Perfiles 17.1
#eselect profile set 3 #Hardened (Estable)
#eselect profile set 4 #Hardened (Estable con SELinux)
#eselect profile set 6 # (Estable preparado para escritorio con GNOME)
#eselect profile set 7 # (Estable preparado para escritorio con GNOME y systemd)
#eselect profile set 8 # (Estable preparado para escritorio KDE Plasma)
#eselect profile set 9 # (Estaple preparado para escritorio KDE Plasma y systemd)
#eselect profile set 13 # (No multi-lib estable y hardened)
#eselect profile set 14 # (No multi-lib estable, hardened y con SELinux)
#Perfiles 17.0
#eselect profile set 19 # Hardened (Estable)
#eselect profile set 20 # Hardened con SELinux (Estable)
#eselect profile set 22 # Escritorio con GNOME (Estable
#eselect profile set 23 # Escritorio con GNOME y systemd
#eselect profile set 24 # Escritorio con KDE Plasma 
#eselect profile set 25 # Escritorio con KDE Plasma y systemd
#eselect profile set 28 # No multilib hardened
#eselect profile set 29 # No multilib hardened con SELinux
# Actualizar @world
emerge -t --update --deep --with-bdeps=y --newuse world && eix-update && perl-cleaner all && python-updater && eclean distfiles && eclean packages
# Setear zona horaria
echo "Europe/Madrid" > /etc/timezone
emerge --config sys-libs/timezone-data
# Local config (Lenguaje)
echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=\"es_ES.UTF-8\"" > /etc/env.d/02locale
# Descargar y generar Kernel
# Version genkernel
emerge gentoo-sources
ls -l /usr/src/linux
emerge genkernel
genkernel all
# Configurar red
echo "Introduce el hostname del equipo:"
read hostname
echo $hostname > /etc/conf.d/hostname
# Activamos DHCP
echo "config_eth0=\"dhcp\"" > /etc/conf.d/net
# Activamos configuracion de red al arrancar el sistema
touch /etc/udev/rules.d/80-net-name-slot.rules
cd /etc/init.d
ln -s net.lo net.eth0
rc-update add net.eth0 default
# Instalar cron
emerge sys-process/fcron
rc-update add fcron default
crontab /etc/crontab
# Instalar sysklogd
emerge app-admin/sysklogd
rc-update add sysklogd default
# mLocate
emerge sys-apps/mlocate
# Herramientas gestion FS
emerge sys-fs/e2fsprogs # se utiliza para administrar Ext2, Ext3, EXT4
emerge sys-fs/xfsprogs  # se utiliza para administrar XFS
emerge sys-fs/reiserfsprogs # se utiliza para administrar ReiserFS
emerge sys-fs/jfsutils # se usa para administrar JFS
emerge sys-fs/dosfstools # se utiliza para administrar VFAT (como FAT32, NTFS, etc.)
emerge sys-fs/btrfs-progs # se utiliza para administrar Btrfs
# root password
passwd
# Establecer teclado
echo "keymap=\"es\"" > /etc/conf.d/keymaps
# Configurar reloj del sistema
echo "clock=\"UTC\"" > /etc/conf.d/hwclock
# Programas necesarios
emerge dhcpcd pciutils gentoolkit
rc-update add dhcpcd default
# Instalacion de GRUB 
echo GRUB_PLATFORMS="efi-64" >> /etc/portage/make.conf
emerge os-prober sys-boot/grub:2
grub-install /dev/sda
# Solo UEFI
# grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
# Salir de chroot, desmontar particiones y reiniciar
exit
cd ..
cd ..
umount -l /mnt/gentoo/dev{/pts,/shm,}
umount -l /mnt/gentoo{/boot,/home,/sys,/proc,}
reboot
