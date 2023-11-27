for x in `cat ips.txt`; do echo -en "\n##### $x #####\n\n" ; ssh -q root@$x 'echo "=====================================================================================================" ;
echo "hostname"
hostname
echo "=====================================================================================================" ;
echo "Versao de SO"
cat /etc/redhat-release
echo "=====================================================================================================" ;
echo "Console"
ipmitool lan print | grep Address
echo "=====================================================================================================" ;
echo "Uptime"
uptime | grep up
echo "=====================================================================================================" ;
echo "HBAs"
lspci | grep -iE "fib|hba|Emulex|Qlogic"
echo "=================================" ;
echo "Status Online  *" ; systool -c fc_host -v | egrep "Class Device =|port_name|port_state" | grep "Online" | wc -l
echo "=================================" ;
systool -c fc_host -v | egrep "Class Device =|port_name|port_state"
echo "=====================================================================================================" ;
echo "Se for Emulex Contar Luns Pela Quantidade de Caminhos"
multipath -ll | grep ready | wc -l
echo "=====================================================================================================" ;
echo "Se nao for Emulex contar a quantidade de Discos"
multipath -ll | grep " dm-" | wc -l
echo "=====================================================================================================" ;
echo "Se nao tiver multipath contar os Discos"
fdisk -l 2>/dev/null | grep -i "Disk /dev/sd" | wc -l
#echo "Relacao de Discos"
#fdisk -l 2>/dev/null | grep -i "Disk /dev/sd"
echo "=====================================================================================================" ;
echo "Express Lane"
cat /sys/module/lpfc/parameters/lpfc_EnableXLane
echo "=====================================================================================================" ;
#echo "Discos"
#multipath -ll | grep mpath | wc -l
#echo "=====================================================================================================" ;
#echo "Max Luns"
systool -v -m scsi_mod | grep max_luns
echo "=====================================================================================================" ;
#echo "Max Report Luns"
systool -v -m scsi_mod | grep max_report_luns

echo "Filtro LVM" ; grep -iE "^filter|^globalfilter" /etc/lvm/lvm.conf | wc -l
grep -iE "^filter|^globalfilter" /etc/lvm/lvm.conf
echo "=====================================================================================================" ;
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||" ;
echo "=====================================================================================================" ;
'; done
