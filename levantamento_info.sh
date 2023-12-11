#!/bin/bash

# script_levantamento_info.sh
#
rm -f ~/logs/*

echo -e "\n=================\n HOSTNAME \b \n=================\n"
hostname

echo -e "\n=================\n DATA DE INSTALAÇÃO DO SO \b \n=================\n"
rpm -qi basesystem | grep Install

echo -e "\n=================\n UPTIME \n=================\n"
uptime

echo -e "\n=================\n STATUS HBAs \n=================\n"
systool -c fc_host -v | egrep "Class Device =|port_name|port_state "

echo -e "\n=================\n  MAX LUNS \n=================\n"
systool -v -m scsi_mod | grep max_luns | awk '{print $3}'

echo -e "\n=================\n DISCOS EXTERNOS \n=================\n"
DISCOS=$(multipath -ll | grep mpath | wc -l)
PATHS=$(./inq | wc -l)
if [ $DISCOS -eq 0 ]
then
        echo "Não é multipath"
else
        echo " DISCOS: $DISCOS"
        echo " PATHS:  $PATHS"
fi

echo -e "\n=================\n  FILESYSTEM \n=================\n"
df -h

echo -e "\n=================\n  RELEASE \n=================\n"
cat /etc/system-release

echo -e "\n=================\n  RESOLV \n=================\n"
cat /etc/resolv.conf

echo -e "\n=================\n  FSTAB \n=================\n"
cat /etc/fstab

echo -e "\n=================\n  ROTAS \n=================\n"
netstat -nr

#echo -e "\n=================\n  CONEXOES \n=================\n"
#netstat -a -n | grep ^tcp| egrep -i "estabelecida|established"

echo -e "\n=================\n  SYSCTL \n=================\n"
cat /etc/sysctl.conf

echo -e "\n=================\n  LIMITS \n=================\n"
cat /etc/security/limits.conf

echo -e "\n=================\n  SERVIÇOS EM EXECUÇÃO \n=================\n"
pstree

echo -e "\n=================\n  IFCONFIG \n=================\n"
ifconfig

echo -e "\n=================\n  CRONTAB ROOT \n=================\n"
crontab -l

echo -e "\n=================\n  DMIDECODE \n=================\n"
dmidecode -t1

echo -e "\n=================\n  CONTROLM \n=================\n"
rpm -qa | grep -i control

echo -e "\n=================\n  LS /OPT/CONTROLM \n=================\n"

ls -l /opt/controlm/
if [ $? -gt 0 ]
then
        echo " Diretório /opt/controlm não existe"
fi


echo -e "\n=================\n  MPATH.CONF \n=================\n"
grep -o '^[^\#]*' /etc/multipath.conf | grep '[^[:space:]]'


echo -e "\n=================\n  LVM.CONF \n=================\n"
grep -o '^[^\#]*' /etc/lvm/lvm.conf | grep '[^[:space:]]'

echo -e "\n=================\n  HOSTS \n=================\n"
cat /etc/hosts

echo -e "\n=================\n  BANCO DE DADOS \n=================\n"
BANCO=$(ps -ef | grep -v grep | grep pmon | wc -l)
CONEXOES=$(netstat -a -n | grep ^tcp| egrep -i "estabelecida|established" | grep 1521)

if [ $BANCO -eq 0 ]
then
        echo "O servidor não possui banco instalado"
else
        echo "A maquina possui banco"
        ps -ef | grep -v grep | grep pmon
        echo "Conexões: $CONEXOES"
fi

echo -e "\n=================\n  MEM \n=================\n"
free -g;

echo -e "\n=================\n  CPUs \n=================\n"
cat /proc/cpuinfo | grep process | wc -l

echo -e "\n=================\n  IP CONSOLE \n=================\n"
ipmitool lan print 2>&-

IPMITOOL_MODE=$(modprobe ipmi_si ; modprobe ipmi_devintf ; ipmitool lan print)

if [ $? -nt 0 ]
then
        echo $IPMITOOL_MODE 2>&-
else
        dmidecode -t1 | grep -i Manufacturer
fi

echo -e "\n\n==========================================================================\n\n"

#Função para validar se o ambiente possui Veritas configurado

checa_veritas(){
VERITAS=$(/opt/VRTS/bin/hastatus -sum)

if [ $? -eq 0 ]
then
        echo -e "\n\n*******ATENÇÃO O AMBIENTE POSSUI CLUSTER VERITAS***********\n\n"
        hastatus -sum

else
        echo -e "\n\n***************AMBIENTE SEM CLUSTER VERITAS************\n\n"
fi
}
checa_veritas 2> /dev/null
