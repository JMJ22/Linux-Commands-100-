echo "=============================================================" ;
echo "Valores atuais do Load Average           (1 min, 5 mins, 15 mins)" ; uptime;
echo "=============================================================" ;
echo "Sumarização de Consumo" ; ps axo user,pcpu,pmem,rss --no-heading | awk '{pCPU[$1]+=$2; pMEM[$1]+=$3; sRSS[$1]+=$4} END {for (user in pCPU) if (pCPU[user]>0 || sRSS[user]>10240) printf "%s:@%.1f%% of total CPU,@%.1f%% of total MEM@(%.2f GiB used)\n", user, pCPU[user], pMEM[user], sRSS[user]/1024/1024}' | column -ts@ | sort -rnk2 | head -n 5 ;
echo "=============================================================" ;
echo "FileSysytem" ; df | awk '{print $(NF-1), $NF}' | sort -n -r | head -n 3 ;
echo "=============================================================" ;
echo "Inodes" ; df -i | awk '{print $(NF-1), $NF}' | sort -n -r | head -n 3 ;
echo "=============================================================" ;
echo "Memória" ; free -m | grep -E "Mem|Swap" | awk '{if ($1 == "Mem:") {mem_total = $2; mem_used = $3; mem_free = $4} else {swap_total = $2; swap_used = $3; swap_free = $4}} END {mem_percent_used = (mem_used / mem_total) * 100; swap_percent_used = (swap_used / swap_total) * 100; mem_percent_free = (mem_free / mem_total) * 100; swap_percent_free = (swap_free / swap_total) * 100; printf "Memória total: %dMB\nMemória usada: %dMB (%.2f%%)\nMemória livre: %dMB (%.2f%%)\nSwap total: %dMB\nSwap usado: %dMB (%.2f%%)\nSwap livre: %dMB (%.2f%%)\n", mem_total, mem_used, mem_percent_used, mem_free, mem_percent_free, swap_total, swap_used, swap_percent_used, swap_free, swap_percent_free}';
echo "=============================================================" ;
echo "Informações do Sistema" ; uname -a ;
echo "============================================================="
