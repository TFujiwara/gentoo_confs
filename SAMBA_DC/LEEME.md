# Instalación de Samba como controlador de dominio en Gentoo
Flags USE que se usan en esta instalación de Samba:
```
- acl (Añade soporte para ACLs)
- addc (Añade soporte para montar un controlador de dominio de Active Directory)
- ads (Añade soporte para Active Directory)
- cups (Añade soporte para CUPS)
- client (Activa la parte cliente de samba)
- gpg (Se usa para el controlador de dominio)
- ldap (Añade soporte para LDAP)
- pam (Añade soporte para autenticación PAM)
- quota (Añade soporte para cuotas de disco)
- regedit (Añade y activa la herramienta regedit por consola)
- system-heimdal (Usa app-crypt/heimdal en vez del que viene en el paquete por defecto)
- winbind (Añade soporte para el demonio de autenticación winbind)
```

Podemos verificar que las flag USE son las correctas, o ver todas las que tiene el paquete por si nos interesa activar alguna en especial, con el siguiente comando:
```
emerge -pv net-fs/samba
```
Copiar los package.use en la ruta */etc/portage/package.use/* para poder instalar Samba sin usar la versión de Kerberos del MIT, ya que la de heimdall tiene mejor soporte y está
integrada en Samba 4.

Una vez copiados, ejecutamos los siguientes comandos en una terminal nueva o en la terminal que tengamos abierta, para instalar samba:
```
emerge net-fs/samba
emerge net-fs/cups (Instalamos el servidor de impresión CUPS)
emerge net-print/hplip (Servidor de impresión Samba de HP).
```
Creamos los directorios para las impresoras compartidas:
```
mkdir /etc/samba/printer
mkdir /var/spool/samba
mkdir /home/samba/public
```
Editamos la base de datos SAM:
```
pdbedit -a root
```
Actualizamos la configuración de NetBIOS:
```
nano -w /etc/nsswitch.conf
hosts: files dns wins
```
En caso de que vayamos a usar la misma máquina que hace de controlador de dominio como file server, crearemos los directorios donde irán los datos compartidos y daremos los permisos correspondientes:
```
mkdir /home/samba
mkdir /home/samba/public
chmod 755 /home/samba
chmod 755 /home/samba/public
```
## Preparando la Instalación del controlador de dominio

NOTA: No podemos elegir nombres como PDC o BDC al elegir el hostname.

Verificamos que no tenemos en marcha Samba, si lo tenemos en marcha, paramos el servicio:

```
ps ax | egrep "samba|smbd|nmbd|winbindd"
```

Si el comando nos devuelve alguno de los procesos relacionados con samba, pararemos el proceso.

Verificamos que en nuestro /etc/hosts del servidor controlador de dominio se resuelve de forma correcta el FQDN y el nombre corto del host con la IP local del controlador de dominio.

# Provisionamiento de un controlador de dominio de Active Directory
Podemos aprovisionar un controlador de dominio nuevo en Active Directory con los siguientes comandos:
```
# Modo interactivo
samba-tool domain provision --use-rfc2307 --interactive

# Modo no interactivo (ideal para automatizar)
samba-tool domain provision --server-role=dc --use-rfc2307 --dns-backend=SAMBA_INTERNAL --realm=SAMDOM.EXAMPLE.COM --domain=SAMDOM --adminpass=Passw0rd

# Crear una zona DNS inversa 
samba-tool dns zone create <IP de nuestro host o hostname> -U Administrator
```
# Arranque del controlador de dominio Samba
Teneis los script de arranque disponibles en la carpeta */etc* de este directorio de mi repo de Github.
Lo suyo sería crear un servicio que arrancara automaticamente al inicio del sistema el controlador de dominio, aún estoy investigando como hacerlo con OpenRC.







