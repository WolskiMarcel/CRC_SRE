#!/bin/bash

echo "create users"

sudo useradd -m -s /bin/bash prometheus

echo "correct permissions"

sudo mkdir -p /home/prometheus/
sudo chown -R prometheus:prometheus /home/prometheus/
sudo chown -R prometheus:prometheus /etc/

echo "download packages"

sudo wget -P /home/prometheus/ https://github.com/prometheus/prometheus/releases/download/v2.45.3/prometheus-2.45.3.linux-amd64.tar.gz
sudo wget -P /home/prometheus/ https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
sudo wget -P /home/prometheus/ https://github.com/prometheus-community/postgres_exporter/releases/download/v0.12.0-rc.0/postgres_exporter-0.12.0-rc.0.linux-amd64.tar.gz
sudo wget -P /home/prometheus/ https://github.com/prometheus/alertmanager/releases/download/v0.27.0/alertmanager-0.27.0.linux-amd64.tar.gz

echo "unpack archives"

sudo tar -xvf /home/prometheus/prometheus-2.45.3.linux-amd64.tar.gz -C /home/prometheus
sudo tar -xvf /home/prometheus/node_exporter-1.7.0.linux-amd64.tar.gz -C /home/prometheus
sudo tar -xvf /home/prometheus/postgres_exporter-0.12.0-rc.0.linux-amd64.tar.gz -C /home/prometheus
sudo tar -xvf /home/prometheus/alertmanager-0.27.0.linux-amd64.tar.gz -C /home/prometheus

echo "change names to more user friendly"

sudo mv /home/prometheus/prometheus-2.45.3.linux-amd64 /home/prometheus/prometheus
sudo mv /home/prometheus/node_exporter-1.7.0.linux-amd64 /home/prometheus/node_exporter
sudo mv /home/prometheus/postgres_exporter-0.12.0-rc.0.linux-amd64 /home/prometheus/postgres_exporter
sudo mv /home/prometheus/alertmanager-0.27.0.linux-amd64 /home/prometheus/alertmanager

echo "create data dirs"

sudo mkdir -p /home/prometheus/prometheus/data
sudo mkdir -p /home/prometheus/alertmanager/data
sudo mkdir -p /home/prometheus/prometheus/rules

sudo mv -f /tmp/conf_files/prometheus.yml /home/prometheus/prometheus/prometheus.yml
sudo mv -f /tmp/conf_files/alerts.yml /home/prometheus/prometheus/rules/alerts.yml
sudo mv -f /tmp/conf_files/alertmanager.yml /home/prometheus/alertmanager/alertmanager.yml

echo "create prometheus service file"

sudo cat > /etc/systemd/system/prometheus.service << EOF
[Unit]
Description=Prometheus Server
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Restart=on-failure
ExecStart=/home/prometheus/prometheus/prometheus --config.file=/home/prometheus/prometheus/prometheus.yml --storage.tsdb.path=/home/prometheus/prometheus/data

[Install]
WantedBy=multi-user.target
EOF

echo "create node_exporter service file"

sudo cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/home/prometheus/node_exporter/node_exporter

[Install]
WantedBy=default.target
EOF

echo "create postgres_exporter service and data files"

sudo cat >  /home/prometheus/postgres_exporter/postgres_exporter.env << EOF
DATA_SOURCE_NAME="postgresql://postgres:postgres@localhost:5432/applications?sslmode=disable"
EOF

sudo cat > /etc/systemd/system/postgres_exporter.service << EOF
[Unit]
Description=Prometheus exporter for Postgresql
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
WorkingDirectory=/home/prometheus/postgres_exporter
EnvironmentFile=/home/prometheus/postgres_exporter/postgres_exporter.env
ExecStart=/home/prometheus/postgres_exporter/postgres_exporter --web.listen-address=:9187 --web.telemetry-path=/metrics
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "create alertmanager service files"

sudo cat > /etc/systemd/system/alertmanager.service << EOF
[Unit]
Description=alertmanager
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
ExecStart=/home/prometheus/alertmanager/alertmanager --config.file=/home/prometheus/alertmanager/alertmanager.yml --storage.path="/home/prometheus/alertmanager/data"
[Install]
WantedBy=default.target
EOF

#off for step in workflow, for manual using uncomment

#echo "enable services"
#systemctl enable prometheus.service node_exporter.service postgres_exporter.service
#echo "start services and check status"
#systemctl start prometheus.service node_exporter.service postgres_exporter.service alertmanager.service
#systemctl status prometheus.service node_exporter.service postgres_exporter.service alertmanager.service
