# 7. Informe de incidente (estilo SOC)

> Ejemplo basado en CU-01. Sustituye los datos por los de tu alerta real.

## INC-2026-001 · Fuerza bruta SSH contra ubuntu-agent

| Campo | Valor |
|---|---|
| Severidad | Media |
| Estado | Contenido / cerrado |
| Detectado por | Wazuh, regla 5712 |
| MITRE ATT&CK | TA0006 Credential Access · T1110 Brute Force |
| Activo afectado | ubuntu-agent (192.168.56.20) |
| Analista | David Zabala |

### Resumen

Se detectaron múltiples intentos fallidos de autenticación SSH desde 192.168.56.50 contra el usuario inexistente `badguy`. La respuesta activa bloqueó la IP origen automáticamente durante 180 s. No hubo ningún acceso con éxito.

### Cronología (UTC+1)

| Hora | Evento |
|---|---|
| hh:mm:ss | Primer intento fallido (regla 5710) |
| hh:mm:ss | Alerta de fuerza bruta (regla 5712, nivel 10) |
| hh:mm:ss | Respuesta activa `firewall-drop` ejecutada |
| hh:mm:ss | Desbloqueo automático (timeout) |

### Indicadores de compromiso (IOC)

- IP origen: `192.168.56.50`
- Usuario intentado: `badguy`
- Herramienta probable: Hydra, por el patrón y la cadencia de los intentos

### Impacto

Ninguno: no hubo credenciales comprometidas.

### Acciones y recomendaciones

1. Desactivar `PasswordAuthentication` y usar solo claves SSH.
2. Mantener la respuesta activa y valorar un `timeout` mayor.
3. Restringir SSH por IP de origen o a través de una VPN.

### Evidencias

- `evidencias/alertas/inc-001-5712.json`
- `evidencias/capturas/inc-001-threat-hunting.png`
- `evidencias/capturas/inc-001-iptables.png`

### Equivalencia en SIEM comerciales

| Wazuh | Microsoft Sentinel | Splunk |
|---|---|---|
| Regla 5712 | Analytics rule (KQL) | Correlation search (SPL) |
| Active response | Playbook (Logic Apps) | SOAR playbook |
| Threat Hunting | Hunting queries | Search & Reporting |
