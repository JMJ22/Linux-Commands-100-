#!/bin/bash
# for i in server1 server2 ; do ssh -Tql root $i < fscheck.sh ;done


print_separator() {
    echo
    printf '%.0s=-=' {1..28}
    echo
}

echo -e "\n ...: Hostname:" $(hostname)

FSTAB_OUTPUT=$(egrep -v 'UUID|LABEL|#|^$' /etc/fstab | egrep 'swap|xfs|ext' | awk '{print $1}')
echo -e "\n ...: fscheck (fstab .vs. blkid)"

for DEVICE in $FSTAB_OUTPUT; do
    MOUNT_POINT=$(grep -w "$DEVICE" /etc/fstab | awk '{print $3}')
    ls $DEVICE >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        blkid $DEVICE | grep -w $MOUNT_POINT >/dev/null 2>&1
        if [[ $? == 0 ]]; then
            echo "- $DEVICE ok"
        else
            echo "..."
            echo -e "$DEVICE -- FS divergente (ajustar FS no fstab) -- ATTENTION"
            grep -w $DEVICE /etc/fstab
            blkid $DEVICE
            echo "..."
        fi
    else
        echo "- $DEVICE -- Nao encontrado (item a mais no fstab) -- ATTENTION"
    fi
done ;

print_separator
