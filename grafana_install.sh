#!/bin/bash

echo "download package"

sudo wget -q -O gpg.key https://rpm.grafana.com/gpg.key

echo "importing key GPG key"

sudo rpm --import gpg.key

echo "grafana config"

sudo tee /etc/yum.repos.d/grafana.repo > /dev/null <<'EOF'
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
exclude=*beta*
EOF

echo "grafana installing"

sudo dnf install grafana -y

sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server
