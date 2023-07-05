#!/bin/bash
export MYIP=$(hostname -I | cut -f1 -d" " | tr -d '[:space:]')
sudo systemctl stop systemd-resolved
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.old
printf 'server=8.8.8.8\nserver=8.8.4.4\nserver=9.9.9.9\nserver=149.112.112.112\nserver=1.1.1.1\nserver=1.0.0.1\nlisten-address=127.0.0.1\ndomain='$DOMAIN'\nmx-host='$DOMAIN','$HOSTNAME',0\naddress=/'$HOSTNAME'/'$MYIP'\n' | tee -a /etc/dnsmasq.conf >/dev/null
mv /etc/resolv.conf /etc/resolv.conf.old
echo "nameserver 127.0.0.1" > /etc/resolv.conf
mv /etc/hosts /etc/hosts.old
printf '127.0.0.1\tlocalhost.localdomain\tlocalhost\n127.0.1.1\tubuntu\n'$MYIP'\t'$HOSTNAME'\tzimbra\t' | tee -a /etc/hosts >/dev/null 2>&1
sudo systemctl restart dnsmasq.service