#!/usr/bin/env bash
# Instala el decoder y las reglas personalizadas de labapp en el manager
# Uso: sudo bash scripts/03-install-custom-rules.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TS=$(date +%Y%m%d-%H%M%S)

for f in decoders/local_decoder.xml rules/local_rules.xml; do
  dest="/var/ossec/etc/${f}"
  [[ -f "$dest" ]] && cp "$dest" "${dest}.bak-${TS}"
  install -o wazuh -g wazuh -m 660 "${REPO_DIR}/configs/manager/$(basename "$f")" "$dest"
  echo "Instalado: $dest (copia de seguridad: ${dest}.bak-${TS})"
done

systemctl restart wazuh-manager
echo "Manager reiniciado. Prueba con: sudo /var/ossec/bin/wazuh-logtest"
