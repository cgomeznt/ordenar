Como hacer un Troubleshooting para consultar SNMP
===================================================

SNMP, del inglés “Simple Network Management Protocol”. El protocolo SNMP se conforma de una base de datos con información dividida en MIB y OID.
Los MIB son como la estructura de directorios de un sistema operativo y los OID son como los archivos que están dentro de esos directorios.

Para poder hacer una consulta de SNMP se deben cumplir ciertos requisitos:
EL servidor o equipo que se le activara el SNMP debe crear un nombre de comunidad para la versión 1 y versión 2 del SNMP.
El servidor o equipo debe permitir la consulta de sus OID, es decir, autorizar cuales servidores pueden hacer los queries de SNMP.
Se debe tener claro que OID se van a consultar, para esto el proveedor debe suministrar una tabla de OID para la interpretación Humana.


El siguiente ejemplo se entiende que dicho servidor o equipo ya cumplió con los requisitos anteriores:

Para consultar todas las MIB y OID que estan disponibles::

	# snmpwalk -v1 -cT3lc0_m0nit0r-123 10.124.0.3
		SNMPv2-MIB::sysDescr.0 = STRING: IBM OS/400 V7R1M0
		SNMPv2-MIB::sysObjectID.0 = OID: SNMPv2-SMI::enterprises.2.6.11
		DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (447275195) 51 days, 18:25:51.95
		SNMPv2-MIB::sysContact.0 = STRING: GERENCIA INFRAESTRUCTURA
		SNMPv2-MIB::sysName.0 = STRING: S10A5967.CREDICARD.COM.VE
		SNMPv2-MIB::sysLocation.0 = STRING:
		SNMPv2-MIB::sysServices.0 = INTEGER: 72
		{...}
		HOST-RESOURCES-MIB::hrDeviceStatus.156 = INTEGER: running(2)
		HOST-RESOURCES-MIB::hrDeviceStatus.157 = INTEGER: running(2)
		HOST-RESOURCES-MIB::hrDeviceStatus.158 = INTEGER: running(2)
		HOST-RESOURCES-MIB::hrDeviceStatus.159 = INTEGER: running(2)
		{...}
		HOST-RESOURCES-MIB::hrSWInstalledDate.27 = STRING: 2017-4-18,3:32:55.0,-4:0
		HOST-RESOURCES-MIB::hrSWInstalledDate.28 = STRING: 2017-4-18,3:32:59.0,-4:0
		HOST-RESOURCES-MIB::hrSWInstalledDate.29 = STRING: 2017-4-18,3:33:40.0,-4:0
		HOST-RESOURCES-MIB::hrSWInstalledDate.30 = STRING: 2017-4-18,3:34:47.0,-4:0


Para consultar un MIB en específico y todos sus OID disponibles::

	# snmpwalk -v1 -cT3lc0_m0nit0r-123 10.124.0.3 .1

	# snmpwalk -v 1 -c T3lc0_m0nit0r-123 10.124.3 .1.2

	# snmpwalk -v 1 -c T3lc0_m0nit0r-123 10.124.0.3 .1.3

Para consultar una OID en específico debemos saber cuál es su nombre y/o dirección.

Si nos dan el nombre podemos descubrir cuál es su dirección::

	# snmptranslate -IR -On snmpInPkts.0
		.1.3.6.1.2.1.11.1.0

Si nos dan la dirección podemos descubrir cuál es el nombre::

	# snmptranslate .1.3.6.1.2.1.11.1.0
		SNMPv2-MIB::snmpInPkts.0

Ahora ya teniendo el nombre o la dirección OID podemos consultar que valor está almacenado::

	# snmpwalk -v1 -ccredicard 10.133.0.198 sysContact.0
		SNMPv2-MIB::sysContact.0 = STRING: CRIPTOGRAFIA@CREDICARD.COM

	# snmpwalk -v1 -ccredicard 10.133.0.198 .1.3.6.1.2.1.1.4.0
		SNMPv2-MIB::sysContact.0 = STRING: CRIPTOGRAFIA@CREDICARD.COM




Ejemplo de cómo consultar todo el SNMP, luego hacer un translate para obtener el OID y como consultar el OID para el resultado.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	# snmpwalk -v1 -ccredicard 10.133.0.198
		SNMPv2-MIB::sysDescr.0 = STRING: NuDesign SNMP agent
		SNMPv2-MIB::sysObjectID.0 = OID: SNMPv2-SMI::enterprises.4096
		DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (1641938311) 190 days, 0:56:23.11
		SNMPv2-MIB::sysContact.0 = STRING: CRIPTOGRAFIA@CREDICARD.COM
		SNMPv2-MIB::sysName.0 = STRING: NuDesign agent
		SNMPv2-MIB::sysLocation.0 = STRING: Toronto
		SNMPv2-MIB::sysServices.0 = INTEGER: 7
		SNMPv2-MIB::sysORLastChange.0 = Timeticks: (0) 0:00:00.00
		SNMPv2-MIB::sysORID.1 = OID: SNMPv2-MIB::snmpBasicComplianceRev2
		SNMPv2-MIB::sysORID.2 = OID: SNMP-FRAMEWORK-MIB::snmpFrameworkMIBCompliances
		SNMPv2-MIB::sysORID.3 = OID: SNMP-MPD-MIB::snmpMPDCompliance
		SNMPv2-MIB::sysORID.4 = OID: SNMP-TARGET-MIB::snmpTargetCommandResponderCompliance
		SNMPv2-MIB::sysORID.5 = OID: SNMP-NOTIFICATION-MIB::snmpNotifyBasicCompliance
		SNMPv2-MIB::sysORID.6 = OID: SNMPv2-SMI::snmpModules.14.3.1.1
		SNMPv2-MIB::sysORID.7 = OID: SNMP-USER-BASED-SM-MIB::usmMIBCompliance
		SNMPv2-MIB::sysORID.8 = OID: SNMP-VIEW-BASED-ACM-MIB::vacmMIBCompliance
		SNMPv2-MIB::sysORDescr.1 = STRING: The MIB module for SNMP entities
		SNMPv2-MIB::sysORDescr.2 = STRING: The SNMP Architecture MIB
		SNMPv2-MIB::sysORDescr.3 = STRING: The MIB for Message Processing and Dispatching
		SNMPv2-MIB::sysORDescr.4 = STRING: This MIB module defines MIB objects which provide mechanisms to remotely configure the parameters used by an SNMP entity for the generation of SNMP messages
		SNMPv2-MIB::sysORDescr.5 = STRING: This MIB module defines MIB objects which provide mechanisms to remotely configure the parameters used by an SNMP entity for the generation of SNMP messages
		SNMPv2-MIB::sysORDescr.6 = STRING: This MIB module defines MIB objects which provide mechanisms to remotely configure the parameters used by a proxy forwarding application
		SNMPv2-MIB::sysORDescr.7 = STRING: The management information definitions for the SNMP User-based Security Model
		SNMPv2-MIB::sysORDescr.8 = STRING: The management information definitions for the View-based Access Control Model for SNMP
		SNMPv2-MIB::sysORUpTime.1 = Timeticks: (0) 0:00:00.00
		SNMPv2-MIB::sysORUpTime.2 = Timeticks: (0) 0:00:00.00
		SNMPv2-MIB::sysORUpTime.3 = Timeticks: (0) 0:00:00.00
		SNMPv2-MIB::sysORUpTime.4 = Timeticks: (0) 0:00:00.00
		SNMPv2-MIB::sysORUpTime.5 = Timeticks: (0) 0:00:00.00
		SNMPv2-MIB::sysORUpTime.6 = Timeticks: (0) 0:00:00.00
		SNMPv2-MIB::sysORUpTime.7 = Timeticks: (0) 0:00:00.00
		SNMPv2-MIB::sysORUpTime.8 = Timeticks: (0) 0:00:00.00
		SNMPv2-MIB::snmpInPkts.0 = Counter32: 609
		SNMPv2-MIB::snmpInBadVersions.0 = Counter32: 0
		SNMPv2-MIB::snmpInBadCommunityNames.0 = Counter32: 248
		SNMPv2-MIB::snmpInBadCommunityUses.0 = Counter32: 0
		SNMPv2-MIB::snmpInASNParseErrs.0 = Counter32: 0
		SNMPv2-MIB::snmpEnableAuthenTraps.0 = INTEGER: enabled(1)
		SNMPv2-MIB::snmpSilentDrops.0 = Counter32: 0
		SNMPv2-MIB::snmpProxyDrops.0 = Counter32: 0

	# snmptranslate -IR -On snmpInPkts.0
		.1.3.6.1.2.1.11.1.0

	# snmpwalk -v1 -ccredicard 10.133.0.198 .1.3.6.1.2.1.11.1.0
		SNMPv2-MIB::snmpInPkts.0 = Counter32: 619

	# snmptranslate -IR -On sysContact.0
		.1.3.6.1.2.1.1.4.0

	# snmpwalk -v1 -ccredicard 10.133.0.198 .1.3.6.1.2.1.1.4.0
		SNMPv2-MIB::sysContact.0 = STRING: CRIPTOGRAFIA@CREDICARD.COM

	# snmpwalk -v1 -ccredicard 10.133.0.198 sysContact.0
		SNMPv2-MIB::sysContact.0 = STRING: CRIPTOGRAFIA@CREDICARD.COM


 






