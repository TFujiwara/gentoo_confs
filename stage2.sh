source /etc/profile
export PS1="(chroot) $PS1"
# Actualizar portage
emerge-webrsync
emerge --sync --quiet
# Elegir perfil de instalación, descomentar esta linea una vez se tenga claro.
# eselect profile set 
# Actualizar @world
emerge -uaDN @world
# Setear zona horaria
echo "Europe/Madrid" > /etc/timezone
emerge --config sys-libs/timezone-data
# Local config (Lenguaje)
nano -w
# Descargar y generar Kernel
# Editar fstab
# Configurar red
# root password
# Establecer teclado
# Configurar reloj del sistema
# Programas necesarios
# Instalacion de GRUB 
# Salir de chroot, desmontar particiones y reiniciar
