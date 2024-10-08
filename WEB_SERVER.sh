#!/bin/bash

# Solicitar datos al usuario
read -p "Ingrese nombre del directorio del proyecto (ejemplo: BVM, FWI): " proy
read -p "Ingrese el NIC a utilizar (ejemplo: eth0, ens33): " nic
read -p "Ingrese el nombre de dominio (por ejemplo, ejemplo.com): " domain
read -p "Ingrese la IP pública del servidor (para configurar DNS): " public_ip
read -p "¿La web será accesible desde el exterior o solo en LAN? (exterior/lan): " access_type

# Verificar si el directorio existe
directory="/home/ubuntu/$proy"
if [ ! -d "$proy" ]; then
    echo "El directorio $proy no existe. Creándolo ahora..."
    sudo mkdir -p "$proy"
    sudo chown ubuntu:ubuntu "$proy"
    echo "Directorio $proy creado y permisos ajustados."
else
    echo "El directorio $proy ya existe."
fi

# Actualizar y hacer upgrade del sistema
sudo apt update && sudo apt upgrade -y

# Instalar Apache y OpenSSL
sudo apt install apache2 openssl -y

# Configurar Apache
if [ "$access_type" = "lan" ]; then
    listen_address="127.0.0.1"
else
    listen_address="*"
fi

sudo tee /etc/apache2/sites-available/$domain.conf <<EOF
<VirtualHost $listen_address:80>
    ServerAdmin webmaster@$domain
    ServerName $domain
    DocumentRoot /home/ubuntu/$proy

    <Directory /home/ubuntu/$proy>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Habilitar el nuevo sitio y el módulo SSL
sudo a2ensite $domain.conf
sudo a2enmod ssl

# Generar certificado SSL autofirmado
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/$domain.key -out /etc/ssl/certs/$domain.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=$domain"

# Configurar Apache para HTTPS
sudo tee /etc/apache2/sites-available/$domain-ssl.conf <<EOF
<IfModule mod_ssl.c>
<VirtualHost $listen_address:443>
    ServerAdmin webmaster@$domain
    ServerName $domain
    DocumentRoot /home/ubuntu/$proy

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/$domain.crt
    SSLCertificateKeyFile /etc/ssl/private/$domain.key

    <Directory /home/ubuntu/$proy>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
</IfModule>
EOF

# Habilitar el sitio SSL
sudo a2ensite $domain-ssl.conf

# Reiniciar Apache para aplicar cambios
sudo systemctl restart apache2

# Configurar DNS (esto debe hacerse en el panel de control de DNS del dominio, pero aquí se hace una demostración simple)
echo "Configuración de DNS para $domain"
echo "Apunta el registro A del dominio $domain a la IP $public_ip en tu proveedor de DNS."

echo "La configuración ha finalizado. Por favor, asegúrate de apuntar el dominio a la IP del servidor en tu proveedor de DNS."
