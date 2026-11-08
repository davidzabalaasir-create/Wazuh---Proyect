#!/usr/bin/env bash
# Crea los grupos de agentes y copia su agent.conf centralizado
# Uso (desde la raíz del repo, en el manager): sudo bash scripts/02-create-groups.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SHARED="/var/ossec/etc/shared"

for group in linux windows web; do
  if [[ ! -d "${SHARED}/${group}" ]]; then
    /var/ossec/bin/agent_groups -a -g "$group" -q
    echo "Grupo creado: $group"
  else
    echo "Grupo ya existente: $group"
  fi
done

for group in linux windows; do
  install -o wazuh -g wazuh -m 660 \
    "${REPO_DIR}/configs/shared/${group}/agent.conf" "${SHARED}/${group}/agent.conf"
  echo "agent.conf copiado a ${group}"
done

/var/ossec/bin/verify-agent-conf
echo "Configuración válida. Los agentes la recibirán automáticamente."
