#!/usr/bin/env bash
# Genera eventos de prueba para las reglas 100101-100103 (ejecutar en ubuntu-agent)
# Uso: sudo bash scripts/04-generate-labapp-events.sh [IP_ORIGEN] [N_FALLOS]
set -euo pipefail

SRC_IP="${1:-192.168.56.50}"
FAILS="${2:-6}"
LOG="/var/log/labapp.log"

touch "$LOG"
for _ in $(seq 1 "$FAILS"); do
  echo "$(date +%FT%T) labapp: LOGIN_FAILED user=admin src_ip=${SRC_IP}" >> "$LOG"
  sleep 1
done
echo "$(date +%FT%T) labapp: LOGIN_OK user=david src_ip=192.168.56.1" >> "$LOG"

echo "Generados ${FAILS} fallos desde ${SRC_IP} + 1 login correcto."
echo "Busca en Threat Hunting: rule.id:100102"
