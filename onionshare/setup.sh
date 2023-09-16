#!/usr/bin/env bash

ONION_SHARE='/usr/lib/python3/dist-packages/onionshare/'

sudo bash -c "
 echo 'Modifing OnionShare to allow the app to bind an hidden service to any running server port'
 cp __init__.py $ONION_SHARE
 cp onionshare.py $ONION_SHARE
 cp onionshare.yml /etc/onion-grater.d/
"
