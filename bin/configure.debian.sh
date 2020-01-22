#! /usr/bin/env sh

./install.rails.sh

sudo bash -c "
apt install  default-jre midori imagemagick\
iptables -I OUTPUT -d localhost -p tcp --dport 8983 -j ACCEPT
"

