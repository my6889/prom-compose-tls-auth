#!/bin/bash
set -e
echo "Generating password for basic authentication..."
read -p "Enter the password: " -s PASSWORD
PASSWORD_HASH=$(htpasswd -nbB admin "$PASSWORD" | cut -d ":" -f 2)
cp ./ssl-auth-config/web-auth.yml.example ./ssl-auth-config/web-auth.yml
sed -i "s|YOUR_PASSWORD_HASH|$PASSWORD_HASH|g" ./ssl-auth-config/web-auth.yml
sed -i "s|YOUR_PASSWORD|$PASSWORD|g" ./prometheus/prometheus.yml
cp ./node-exporter/web-auth.yml.example ./node-exporter/web-auth.yml
sed -i "s|YOUR_PASSWORD_HASH|$PASSWORD_HASH|g" ./node-exporter/web-auth.yml

echo "Generating SSL certificate..."
openssl req -x509 -nodes -days 7300 -newkey rsa:2048 \
  -keyout ./ssl-auth-config/server.key \
  -out ./ssl-auth-config/server.crt \
  -subj "/C=CN/ST=Henan/L=Zhengzhou/O=IT/CN=prometheus.local"
chmod 777 ./ssl-auth-config/server.key ./ssl-auth-config/server.crt
echo "Generated SSL certificate and key."

echo "Copying SSL certificate and key to node-exporter directory..."
cp ./ssl-auth-config/server.crt ./node-exporter/server.crt
cp ./ssl-auth-config/server.key ./node-exporter/server.key
tar -czvf node-exporter-installer-copy-this.tar.gz ./node-exporter
echo "Copied SSL certificate and key to node-exporter directory and created tarball."
echo "You can now use the 'node-exporter-installer-copy-this.tar.gz' file to install Node Exporter on your target machine."

echo "Generated password for basic authentication. Please save the following credentials:"
echo "Username: admin"
echo "Password: $PASSWORD"
echo "This Username and Password will be used in Prometheus, Alertmanager, Blackbox Exporter and Node Exporter."