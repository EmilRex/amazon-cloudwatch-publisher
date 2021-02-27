#!/usr/bin/env bash
set -e


# Install dependencies
pip3 install -r requirements.txt


# Create folders and copy source and config
sudo mkdir -p /opt/aws/amazon-cloudwatch-publisher/bin/
sudo mkdir -p /opt/aws/amazon-cloudwatch-publisher/etc/
sudo mkdir -p /opt/aws/amazon-cloudwatch-publisher/logs/
sudo cp amazon-cloudwatch-publisher /opt/aws/amazon-cloudwatch-publisher/bin/
sudo cp configs/amazon-cloudwatch-publisher-rpi.json /opt/aws/amazon-cloudwatch-publisher/etc/amazon-cloudwatch-publisher.json
sudo chown -R pi: /opt/aws/amazon-cloudwatch-publisher
sudo chmod -R u+rwx /opt/aws/amazon-cloudwatch-publisher


# Write the daemon configuration file
sudo cat << EOF > /etc/systemd/system/amazon-cloudwatch-publisher.service
[Unit]
Description=amazon-cloudwatch-publisher
Requires=network.target
After=network.target
StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
Type=simple
User=pi
ExecStart=/opt/aws/amazon-cloudwatch-publisher/bin/amazon-cloudwatch-publisher
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF


# Install the publisher as a daemon that runs at boot, and then start it
sudo systemctl enable amazon-cloudwatch-publisher
sudo systemctl start amazon-cloudwatch-publisher
