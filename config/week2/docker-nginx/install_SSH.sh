#!/bin/bash

SSH_CONFIG="/etc/ssh/sshd_config"
SSH_PORT=2222

set -euo pipefail # Para el script si un comando falla, intenta usar una variable no definida o si detecta un error en el pipeline

# Actualiza APT e instala SSH si no está instalado

sudo apt update
sudo apt install -y openssh-server

if ! sudo systemctl is-active --quiet ssh; then
    echo "No se pudo instalar o habilitar SSH"
    exit 1
else
    echo "SSH ya está instalado y habilitado."
fi

# Crear una copia de seguridad del archivo de configuración original
if [ ! -f "${SSH_CONFIG}.bak" ]; then
    sudo cp "$SSH_CONFIG" "${SSH_CONFIG}.bak"
    echo "Copia de seguridad creada:  ${SSH_CONFIG}.bak"
fi


# Cambiar el puerto SSH si no se ha cambiado ya
if ! grep -q "^Port $SSH_PORT" "$SSH_CONFIG"; then
    	sudo sed -i "s/^#Port 22/Port $SSH_PORT/" "$SSH_CONFIG"
    	echo "Puerto SSH cambiado a $SSH_PORT."
else
	echo "El puerto ya está establecido en $SSH_PORT."
fi

# Deshabilitar el acceso root directo
if ! grep -q "^PermitRootLogin no" "$SSH_CONFIG"; then
    	sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"
    	echo "Login de root deshabilitado."
else
	echo "El login de root ya está deshabilitado."
fi

# Aplicar los cambios
sudo systemctl restart ssh
