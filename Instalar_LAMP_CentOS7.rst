Cómo instalar LAMP en CentOS 7
=================================

Configurar los repositorios EPEL
+++++++++++++++++++++++++++++++++

CentOS sólo ofrecen la versión 5.4.16 de PHP en sus repos, habilitar el soporte EPEL para disponer de paquetes más actualizados.::

	yum -y install epel-release yum-utils
	
Configurar los repositorios para PHP
+++++++++++++++++++++++++++++++++++++++

Añadir repositorio REMI donde encontraremos las versiones actualizadas de PHP::

	yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
	
REMI tiene varias versiones de PHP, debemos habilitar el repositorio del cual necesitamos, en este caso PHP 7.4.::

	yum-config-manager --enable remi-php74
	
Aunque podemos seleccionar otra version de PHP::

	yum-config-manager --enable remi-php55   # [Install PHP 5.5]
	yum-config-manager --enable remi-php56   # [Install PHP 5.6]
	yum-config-manager --enable remi-php72   # [Install PHP 7.2]
	yum-config-manager --enable remi-php73   # [Install PHP 7.3]
	yum-config-manager --enable remi-php74   # [Install PHP 7.4]

Configurar los repositorios para MariaDB
++++++++++++++++++++++++++++++++++++++++++++

CentOS 7 en sus repos tiene una version muy antigua (MariaDB 5.5).

Para utilizar la última versión estable MariaDB 10.4. Creamos un nuevo archivo de repositorio::

	vi /etc/yum.repos.d/mariadb-10.4.repo
	
Con el siguiente contenido::

	[mariadb]
	name = MariaDB
	baseurl = http://yum.mariadb.org/10.4/centos7-amd64
	gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
	gpgcheck=1
	

Actualizamos los repos::

	yum update -y
	
Ahora CentOS 7 puede empezar con la instalación y configuración del sistema LAMP. Para instalar todo el software LAMP los paquetes que necesitaremos son los siguientes:

	httpd
	mariadb-server
	php
	php-mysqlnd

Hacemos la instalación de LAMP::

	yum -y install httpd mariadb-server php php-mysqlnd
	
En este momento ya está instalado todo el software necesario, pero obviamente habrá que hacer ajustes para poder trabajar.


Habilitamos los Systemctl
++++++++++++++++++++++++++

Para que arranquen automáticamente en cada inicio del sistema::

	systemctl enable httpd mariadb
	systemctl start httpd mariadb
	
Firewall
+++++++++++

Excepción para el servicio HTTP::

	firewall-cmd --permanent --zone=public --add-service=http
	
Excepción para el servicio HTTPS::

	firewall-cmd --permanent --zone=public --add-service=https
	
Recargamos la configuración::

	firewall-cmd --reload

Cómo configurar LAMP en CentOS 7
++++++++++++++++++++++++++++++++

Realizar unos mínimos ajustes en LAMP de CentOS.

Apache

Editamos el archivo de configuración::

	vi /etc/httpd/conf/httpd.conf
		...
		# ServerName gives the name and port that the server uses to identify itself.
		# This can often be determined automatically, but we recommend you specify
		# it explicitly to prevent problems during startup.
		#
		# If your host doesn't have a registered DNS name, enter its IP address here.
		#
		#ServerName www.example.com:80
		ServerName centos7.local:80
		....
		
Recargar la configuración del servidor web:::

	systemctl reload httpd
	
Servicio de base de datos

Ejecutar el script mysql_secure_installation::

	mysql_secure_installation
	

PHP

La configuración de PHP se realiza a través de los ajustes del archivo /etc/php.ini. Lo básico a modificar en una nueva instalación sería:

	Zona horaria del servidor
	Tratamiento de errores
	
Para obtener el valor que necesitas para ajustar la zona horaria, puedes consultar en http://php.net/manual/es/timezones.php.

En cuanto a los valores para el tratamiento de errores de PHP, en el propio archivo /etc/php.ini vienen como ejemplo los valores de desarrollo y de producción.

Por ejemplo, editamos php.ini::

	vi /etc/php.ini
		## Para un servidor de desarrollo situado en España, podríamos establecer estos valores en /etc/php.ini:
		...
		[Date]
		; Defines the default timezone used by the date functions
		; http://php.net/date.timezone
		date.timezone = Europe/Madrid
		...
		error_reporting = E_ALL
		...
		display_errors = On
		...
		display_startup_errors = On
		...
		
Si necesitas un servidor de producción (que oculte los mensajes de error) no necesitas cambiar los valores por defecto.

Para evitar ciertos errores de PHP 7.3 en el inicio de algunas aplicaciones web (como WordPress), conviene localizar la sección [Pcre] en el mismo fichero php.ini y añadir esta directiva::

	pcre.jit = 0
	
Tras estos mínimos cambios, podemos guardar y cerrar php.ini.

Recargar la configuración del servidor web tras cada cambio en la configuración de PHP::

	systemctl reload httpd
	

Probar la pila LAMP en CentOS 7
+++++++++++++++++++++++++++++++++++

Para probar la pila LAMP en CentOS 7 crearemos un pequeño script en PHP accesible vía web::

	vi /var/www/html/info.php
	<?php phpinfo();

Abrir la URL con la ruta /info.php