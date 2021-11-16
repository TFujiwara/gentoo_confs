# Configuraciones prácticas de Gentoo
Algunas configuraciones de Gentoo.

### Que es lo que hay aqui?
Aquí habrán varias configuraciones utiles de Gentoo, además de varios scripts para automatizar instalacion y algunas cosas.

Los **.conf** son configuraciones del **make.conf** de portage, el gestor de paquetes de Gentoo, para las diferentes familias de procesadores: AMD, Intel y ARM.

Recomiendo tenerlas a mano o usar solamente la del procesador en la que estemos instalando el sistema. 

El instalador de Gentoo se divide en dos etapas: **stage1.sh** y **stage2.sh**.

El stage1 contiene la descompresión del tar del stage 3 elegido y descomentado previamente en el fichero, pudiendo elegir entre el Desktop y tres hardenizados, uno de ellos con SELinux.

El stage2 contiene el resto de la instalación, en la cual se genera el kernel del sistema y se instala el GRUB en la raíz del disco. 




