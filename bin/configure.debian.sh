#! /usr/bin/env sh

./install.rails.sh

sudo bash -c "
apt install  default-jre midori imagemagick\
iptables -I OUTPUT -d localhost -o lo -p tcp --dport 8983 -m owner --uid-owner 1000 -j ACCEPT
"

# To be able to go on 192.168.0.0/24
# iptables -I OUTPUT -d 192.168.0.0/24 -o lo -p tcp --dport 3000 -m owner --uid-owner 1000 -j ACCEPT

# To be abl to be accessible from the local network
# iptables -I INPUT -p tcp --dport 3000 -s 192.168.0.0/24 -j ACCEPT
