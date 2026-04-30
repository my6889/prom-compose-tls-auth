#!/bin/bash
set -e

echo "========================================="
echo "    Node Exporter Installation Script"
echo "========================================="
echo ""
echo "Please select installation mode:"
echo "  1) Standard (no authentication)"
echo "  2) With TLS & Basic Auth"
echo ""
read -p "Enter your choice [1/2]: " choice

case "$choice" in
  1)
    echo ""
    echo "Installing Node Exporter (Standard)..."
    chmod +x ./node_exporter-1.11.1
    cp ./node_exporter-1.11.1 /usr/local/bin/node_exporter
    cp ./node_exporter.service /etc/systemd/system/node_exporter.service
    ;;
  2)
    echo ""
    echo "Installing Node Exporter (TLS & Basic Auth)..."
    chmod +x ./node_exporter-1.11.1
    cp ./node_exporter-1.11.1 /usr/local/bin/node_exporter
    mkdir -p /etc/node_exporter
    cp ./web-auth.yml /etc/node_exporter/web-auth.yml
    cp ../ssl-auth-config/server.crt /etc/node_exporter/server.crt
    cp ../ssl-auth-config/server.key /etc/node_exporter/server.key
    cp ./node_exporter_auth.service /etc/systemd/system/node_exporter.service
    ;;
  *)
    echo "Invalid choice: $choice. Exiting."
    exit 1
    ;;
esac

systemctl daemon-reload
sleep 0.5
systemctl enable node_exporter
sleep 0.5
systemctl restart node_exporter
sleep 1
ps -ef | grep node_exporter
echo ""
echo "Node Exporter installed successfully (mode: $([ "$choice" = "2" ] && echo "TLS & Basic Auth" || echo "Standard"))."