#!/bin/bash
###############################################################
#
#
#
#______________________________________________________________
# Creado por Carlos Gomez
# Correo: cgome1@cantv.com.ve
# Fecha: 07-04-2014
# CANTV - GOTIC - CSMBD
###############################################################

function mensaje_inicial {
   clear
   echo -e "
   Debe utilizar este script con parametros, ejemplo;

   $scriptname -add <dominio.com> 
   $scriptname -del dominio.com> 

   -add   para bloquear un dominio.
   -del   quitar un dominio del bloqueo.
   "
   exit 1
}

function mensaje_error {
   clear
   echo -e "`mensaje_fecha` ERROR - $1" | escribir_log
   echo -e "`mensaje_fecha` ERROR - Se sale del script, para que verifiquen que puede estar pasando"| escribir_log
   exit 1
}

function mensaje_warn {
   clear
   echo -e "`mensaje_fecha` WARN - $1" | escribir_log
   echo -e "`mensaje_fecha` WARN - Se sale del script, para que verifiquen que puede estar pasando"| escribir_log
   exit 1
}

function mensaje_info {
   echo -e "`mensaje_fecha` INFO - $1" | escribir_log
}

function escribir_log {
  tee -a $ruta_log/$scriptname.log 
}

function mensaje_fecha {
   ANO=`date +%Y`
   MES=`date +%m`
   DIA=`date +%d`
   HORA=`date +%H`
   MIN=`date +%M`
   FECHA=$ANO$MES$DIA-$HORA:$MIN
   echo $FECHA
}

function verificar_dominio {
   cuenta_dominio=`grep $arg2 $ruta_bind/$zones_blocked | wc -l` 
   if [ $cuenta_dominio -eq 0 ] ; then
      mensaje_info "No existe el dominio $arg2, se procede a colocarlo en $zones_blocked en dns-corp-master-01"
      bloquear_dominio
   else
      mensaje_warn "El dominio $arg2 ya existe, por favor verifique"
   fi
}

function bloquear_dominio {
   dominio_bloqueado="zone \"$arg2\" {\n\ttype master;\n\tfile dominio-general.com;\n};"
   echo -e $dominio_bloqueado | tee -a $ruta_bind/$zones_blocked
   if [ $? -eq 0 ] ; then
      mensaje_info "Se agrego la zona $arg2 con exito en el archivo $ruta_bind/$zones_blocked en dns-corp-master-01"
      rndc reload
      if [ $? -eq 0 ] ; then
          mensaje_info "Se recargo el servicio bind con exito en el servidor dns-corp-master-01"
          crear_zones_blocked_slave
      else
          mensaje_error "No se pudo recargar el servicio bind en el servidor dns-corp-master-01 \nRecuerde borrar en $zones_blocked la zona creada que fue $arg2"
      fi
   else
      mensaje_error "No se pudo modificar el archivo de zones.blocked en el master"
   fi 
}

function crear_zones_blocked_slave {
   echo -e  "zone \"$arg2\" {\n\ttype slave;\n\tfile dominio-general.com;\n\tmasters {\n\t\t161.196.64.59;\n\t};\n};" > $ruta_backup/zones.blocked.slave
   if [ $? -eq 0 ] ; then
      mensaje_info "Se creo el archivo zones.blocked.slave en $ruta_backup"
      bloquear_dominio_slave
   else
      mensaje_error "No se pudo crear el archivo zones.blocked.slave en $ruta_backup"
   fi
}

function bloquear_dominio_slave {
    cat /mnt/backups/zones.blocked.slave | ssh dns-corp-nav-01 tee -a /etc/bind/zones.block
   if [ $? -eq 0 ] ;then
      mensaje_info "Se agrego la zona $arg2 con exito en el archivo $ruta_bind/$zones_blocked en el servidor dns-corp-nav-01"
   else
      mensaje_error "NO se agrego la zona $arg2 con exito en el archivo $ruta_bind/$zones_blocked en el servidor dns-corp-nav-01, puede existir problema de conexion o no se pudo ejecutar el rndc reload"
   fi
   cat /mnt/backups/zones.blocked.slave | ssh dns-corp-nav-02 tee -a /etc/bind/zones.block
   if [ $? -eq 0 ] ;then
      mensaje_info "Se agrego la zona $arg2 con exito en el archivo $ruta_bind/$zones_blocked en el servidor dns-corp-nav-02"
   else
      mensaje_error "NO se agrego la zona $arg2 con exito en el archivo $ruta_bind/$zones_blocked en el servidor dns-corp-nav-02, puede existir problema de conexion o no se pudo ejecutar el rndc reload"
   fi
}

###############################################################
# MAIN
###############################################################
scriptname=$0
ruta_bind="/etc/bind"
zones_blocked="zones.blocked"
ruta_log="/var/tmp"
ruta_backup="/mnt/backups"
arg1=$1
arg2=$2

if [ -z $arg1 ] || [ -z $arg2 ] ; then
   mensaje_inicial
else
   case $arg1 in
      -add)
         mensaje_info "El argumento fue -add"
         verificar_dominio
      ;;
      -del)
         mensaje_info "El argumento fue -del"
      ;;
      *)
         mensaje_inicial 
      ;;
   esac
fi
