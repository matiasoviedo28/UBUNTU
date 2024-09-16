#!/bin/bash

# Solicitar confirmación antes de proceder
read -p "Este script eliminará la mayoría de los paquetes instalados y restaurará el sistema a un estado básico. ¿Estás seguro de que deseas continuar? (S/N): " confirm
if [ "$confirm" != "S" ]; then
    echo "Operación cancelada."
    exit 1
fi

# Actualizar el sistema
sudo apt update && sudo apt upgrade -y

# Detener y eliminar servicios comunes (ejemplos)
sudo systemctl stop apache2 mysql postgresql mongodb
sudo systemctl disable apache2 mysql postgresql mongodb
sudo apt purge apache2 mysql-server postgresql mongodb* -y

# Eliminar paquetes adicionales instalados
# Este comando eliminará todos los paquetes no esenciales
sudo apt autoremove --purge -y

# Limpiar el cache de paquetes
sudo apt clean

# Eliminar archivos de configuración restantes
sudo rm -rf /etc/apache2 /etc/mysql /etc/postgresql /etc/mongodb
sudo rm -rf /var/lib/mysql /var/lib/postgresql /var/lib/mongodb
sudo rm -rf /home/ubuntu

# Restaurar archivos de configuración predeterminados (si es necesario)
# Esto puede requerir reinstalar paquetes básicos para restaurar configuraciones
# Ejemplo: sudo apt install --reinstall ubuntu-standard

# Advertencia de reinicio
echo "El sistema se ha limpiado. Es posible que necesite reiniciar el servidor para aplicar todos los cambios."

# Opcional: Reiniciar el sistema
# sudo reboot

echo "La limpieza ha finalizado. Asegúrate de revisar el estado del sistema y restaurar cualquier servicio necesario."

