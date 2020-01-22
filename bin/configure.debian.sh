#! /usr/bin/env sh

RUBY_DIR="../vendor/ruby"
mkdir -p $RUBY_DIR
export GEM_HOME=$RUBY_DIR
export GEM_PATH=$RUBY_DIR
alias bundle="torsocks bundle"
alias gem="torsocks gem"

sudo bash -c "
apt install  default-jre midori imagemagick rails javascript-common ruby-dev build-essential libsqlite3-dev libxml2-dev zlib1g-dev yarnpkg\
iptables -I OUTPUT -p tcp -d localhost --dport 3000 -j ACCEPT\
iptables -I OUTPUT -d localhost -o lo -p tcp --dport 8983 -m owner --uid-owner 1000 -j ACCEPT
"

# To be able to go on 192.168.0.0/24
# iptables -I OUTPUT -d 192.168.0.0/24 -o lo -p tcp --dport 3000 -m owner --uid-owner 1000 -j ACCEPT

# To be abl to be accessible from the local network
# iptables -I INPUT -p tcp --dport 3000 -s 192.168.0.0/24 -j ACCEPT
