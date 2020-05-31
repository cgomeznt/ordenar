Como saber cuál es la Promedio de Carga máxima (Load Average) de un servidor
================================================================================

Los valores de "promedio de carga" indican cuán ocupados están la CPU, el disco y otros recursos de su sistema. 

La carga se expresa en procesos de espera y subprocesos No es un valor instantáneo, sino un promedio, y
su interpretación debe incluir el número de núcleos de CPU, y Puede incrementar el  I/O de espera como lecturas de discos.


Como visualizar el promedio de carga
++++++++++++++++++++++++++++++++++++

Existen muchos comandos pero estos son los más utilizados.::

	upload
	top
	nmon
	w
	cat /proc/loadavg

Estos comando siempre nos suministraran tres valores, ejemplo::

	load average: 1.21, 0.73, 0.72

cada valor es la media de los últimos minutos, los leemos de izquierda a derecha, el primer valor es el promedio de 1 minuto, el segundo valor el promedio de 5 minutos y el tercer valor el promedio de 15 minutos.

	* 1.21 - es el promedio de 1 minuto
	* 0.73 - es el promedio de 5 minutos
	* 0.72 - es el promedio de 15 minutos
	
Como interpretar el promedio de carga
+++++++++++++++++++++++++++++++++++++++

Lo primero que se debe tener claro, es cuantos procesadores tiene el servidor y saber si estos procesadores tienen núcleos (cores).

*Para saber cuántos procesadores tiene el server* ::

	cat /proc/cpuinfo | grep processor | wc -l
	4

Esto nos indica que tenemos 4 procesadores.

*Para saber cuántos núcleos (cores) tiene cada procesador* ::

	# cat /proc/cpuinfo | grep "cpu cores"
	cpu cores       : 4
	cpu cores       : 4
	cpu cores       : 4
	cpu cores       : 4
	
Esto nos indica que cada procesador tiene 4 cores, en total el servidor tiene 16 cores.

TIPS: Cuando tenemos varios cores nuestros procesadores son *Multi-Nucleos*, si solo tenemos procesadores entonces hablamos de *Mono Nucleos*

En este sistema en particular con 16 núcleos (cores), la carga máxima para decir que el servidor está al 100% es de 16.00 al visualizar el load average.


Ejemplos
+++++++++++++

En estos ejemplos utilizaremos un sistema con 16 núcleos (cores).


Veamos este ejemplo utilizando un servidor con 4 procesadores de 4 núcleos (cores) cada uno, un total de 16 núcleos (cores). consultamos el load average::

	# uptime
	 14:27:25 up 5 days, 16:12,  5 users,  load average: 8.07, 12.60, 23.70
	 
El 8.07 podemos interpretar que durante un minuto de los 16 núcleos solo 9 están siendo utilizados, 8 núcleos al 100% y el núcleo 9 solo el 7%.

Otro ejemplo::

	# uptime
	 14:27:25 up 5 days, 16:12,  5 users,  load average: 14.06, 22.07, 43.01
	 
El 14.06 podemos interpretar que durante un minuto de los de 16 núcleos solo 15 están siendo utilizados, 14 núcleos al 100% y el núcleo 15 solo el 6%.


Ahora un ejemplo crítico ::

	# uptime
	 14:27:25 up 5 days, 16:12,  5 users,  load average: 16.06, 32.07, 42.01
	 
El 16.06 podemos interpretar que durante un minuto los 16 núcleos están siendo utilizados al 100% y existe un 6% de procesos encolados.


Un ejemplo crítico para correr ::

	# uptime
	 14:27:25 up 5 days, 16:12,  5 users,  load average: 40.25, 60.17, 82.03
	 
El 40.25 podemos interpretar que los 16 núcleos están siendo utilizados al 100% y existe un 2426% de procesos encolados y alto I/O.

Todos los ejemplos anteriores debemos ir viendo el vmstat para ver los I/O y el IDLE de los CPU.
