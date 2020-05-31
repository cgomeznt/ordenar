Como hacer un Troubleshooting sobre puertos UDP
===================================================

Lo primero que siempre se recomienda es con el comando **nmap** realizar un escaneo del puerto UDP que se quiere saber si esta en escucha.
Este comando lo ejecutamos de forma remota, es decir, nos paramos en un servidor que tenga el comando y que pueda llegar por RED al servidor o equipo que queremos consultar el UDP

Este es un ejemplo con un resultado exitoso::

	# nmap -p 161 -sU -P0 10.136.0.90
		Starting Nmap 6.40 ( http://nmap.org ) at 2020-05-06 19:08 -04
		Nmap scan report for 10.136.0.90
		Host is up.
		PORT    STATE         SERVICE
		161/udp open|filtered snmp
		Nmap done: 1 IP address (1 host up) scanned in 7.59 seconds

Este es un ejemplo con un resultado Fallido::

	# nmap -p 162 -sU -P0 10.133.0.198
		Starting Nmap 6.40 ( http://nmap.org ) at 2020-05-06 19:10 -04
		Nmap scan report for 10.133.0.198
		Host is up (0.00041s latency).
		PORT    STATE  SERVICE
		162/udp closed snmptrap
		MAC Address: 00:D0:FA:05:42:3E (Thales e-Security)
		Nmap done: 1 IP address (1 host up) scanned in 5.60 seconds

La segunda opcion es verificar el puerto UDP con el comando **nc**

Este es un ejemplo con un resultado exitoso::

	# nc -vz -u 10.130.1.43 161
		Ncat: Version 7.50 ( https://nmap.org/ncat )
		Ncat: Connected to 10.130.1.43:161.
		Ncat: UDP packet sent successfully
		Ncat: 1 bytes sent, 0 bytes received in 2.01 seconds.

Este es un ejemplo con un resultado Fallido::

	# nc -vz -u 10.133.0.198 53
		Ncat: Version 7.50 ( https://nmap.org/ncat )
		Ncat: Connected to 10.133.0.198:53.
		Ncat: Connection refused.


