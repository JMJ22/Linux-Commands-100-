#!/bin/bash
for host in $(cat ips.txt); do
  if ping -c 3 $host >/dev/null; then
    echo "$host responde a ping"
  else
    echo "$host não responde a ping"
  fi
done
