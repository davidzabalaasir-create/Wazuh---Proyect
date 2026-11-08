#!/usr/bin/env bash
# Instalación todo en uno de Wazuh 4.14 (manager + indexer + dashboard)
# Uso: sudo bash scripts/01-install-server.sh
set -euo pipefail

WAZUH_VERSION="4.14"

if [[ $EUID -ne 0 ]]; then
  echo "Ejecuta como root (sudo)." >&2
  exit 1
fi

RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
if (( RAM_GB < 7 )); then
  echo "Aviso: solo ${RAM_GB} GB de RAM. Se recomiendan 8 GB." >&2
fi

cd /root
curl -sO "https://packages.wazuh.com/${WAZUH_VERSION}/wazuh-install.sh"
bash ./wazuh-install.sh -a

# Desactivar el repositorio para evitar actualizaciones accidentales
if [[ -f /etc/apt/sources.list.d/wazuh.list ]]; then
  sed -i "s/^deb /#deb /" /etc/apt/sources.list.d/wazuh.list
  apt-get update -qq
fi

echo
echo "Instalación terminada. Contraseñas:"
echo "  sudo tar -O -xvf /root/wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt"
