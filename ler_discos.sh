for z in `lsblk | grep ' disk' | awk {'print $1'}`; do echo -en "$z : " ; od -cN 4096 /dev/$z | wc -l;done
