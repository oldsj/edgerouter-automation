#!/bin/vbash
sudo mv /tmp/acme.sh /config/.acme.sh/acme.sh
sudo mv /tmp/renew.acme.sh /config/scripts/renew.acme.sh
sudo chmod 755 /config/.acme.sh/acme.sh /config/scripts/renew.acme.sh
sudo chown -R root:root /config/.acme.sh /config/scripts/renew.acme.sh
sudo chmod -R 755 /config/.acme.sh /config/scripts/renew.acme.sh