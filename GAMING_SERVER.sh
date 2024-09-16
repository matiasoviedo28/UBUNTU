#INSTALADOR DE MINECRAFT SERVER EN UBUNTU SERVER
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'
YELLOW='\033[0;33m'
clear
echo -e "${RED}EJECUTANDO INSTALADOR DE MINECRAFT SERVER${RESET}"
echo -e "${RED}IMPORTANTE, EJECUTAR ESTE BASH COMO SUDO${RESET}"
sleep 1
clear
echo -e "${BLUE}INFO:${RESET}"
echo "SOFTWARE:"
lsb_release -a
sleep 1

#ACTUALIZAR
echo -e "${BLUE}ACTUALIZANDO${RESET}"
apt-get update
apt-get upgrade
echo -e "${GREEN}ACTUALIZADO${RESET}"

#INSTALAR HERRAMIENTAS BASICAS
echo -e "${BLUE}INSTLANDO HERRAMIENTAS BASICAS${RESET}"
apt install openssh-server
apt install htop
systemctl enable ssh
echo -e "${GREEN}HERRAMIENTAS BASICAS INSTALADAS${RESET}"

#CONFIGURAR PUERTOS
echo -e "${BLUE}CONFIGURANDO PUERTOS${RESET}"
ufw enable
ufw allow 25565/tcp
ufw allow 22/tcp
ufw status
echo -e "${GREEN}PUERTOS CONFIGURADOS${RESET}"

#CREAR CARPETAS
echo -e "${BLUE}CREANDO DIRECTORIOS${RESET}"
mkdir /home/ubuntu/SERVER
echo -e "${GREEN}DIRECTORIOS CREADOS${RESET}"

#INSTALACION JAVA
echo -e "${BLUE}DESCARGANDO ENTORNO JAVA${RESET}"
apt-get install default-jre
wget -O /home/ubuntu/SERVER/server.jar https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar
echo -e "${GREEN}JAVA DESCARGADO e INSTALADO${RESET}"


#CREAR ARRANCADOR
echo -e "${BLUE}CREANDO RUN.SH${RESET}"
echo "java -Xmx2048M -Xms1024M -jar server.jar nogui" >> /home/ubuntu/SERVER/RUN.sh
chmod 777 /home/ubuntu/SERVER/RUN.sh
echo -e "${GREEN}RUN.SH CONFIGURADO${RESET}"

echo "ahora modifica esto y ya tendrás el servidor funcional:"
echo -e "${YELLOW}eula.txt${RESET}"
echo -e "${YELLOW}server.propietes online-mode=false${RESET}"
echo -e "${YELLOW}server.propietes server-ip=${RESET}"