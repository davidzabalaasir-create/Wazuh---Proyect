# Evidencias

Checklist de capturas y alertas del proyecto. Marca cada una al guardarla.

- **Capturas:** `capturas/`, en PNG, con el nombre indicado.
- **Alertas:** `alertas/`, en JSON. Cópialo desde *Threat Hunting* → abrir la alerta → pestaña JSON.

> 🔐 Antes de subir nada, tapa las contraseñas, los tokens y las IPs públicas reales.

## Instalación y agentes

- [ ] `01-instalacion-resumen.png`: salida final de `wazuh-install.sh`, con la contraseña tapada.
- [ ] `02-dashboard-inicio.png`: pantalla principal del dashboard.
- [ ] `03-agentes-activos.png`: *Agents* con ubuntu-agent y windows-agent en *Active*.
- [ ] `04-grupos.png`: grupos `linux` y `windows` con sus agentes.
- [ ] `05-sysmon-eventos.png`: eventos de Sysmon en *Threat Hunting*.

## CU-01 · Fuerza bruta SSH

- [ ] `cu01-hydra.png`: terminal de Kali ejecutando Hydra.
- [ ] `cu01-alerta-5712.png`: *Threat Hunting* filtrado por `rule.id:5712`.
- [ ] `cu01-iptables.png`: `iptables -L -n` en la víctima con la IP bloqueada.
- [ ] `cu01-notificacion.png`: aviso en Telegram o Slack.
- [ ] `alertas/cu01-5712.json`

## CU-02 · FIM

- [ ] `cu02-fim-eventos.png`: eventos de añadido, modificado y borrado.
- [ ] `cu02-fim-diff.png`: detalle con el cambio de contenido (`report_changes`).
- [ ] `alertas/cu02-550.json`

## CU-03 · VirusTotal

- [ ] `cu03-virustotal.png`: alerta de VirusTotal sobre EICAR.
- [ ] `cu03-borrado.png`: alerta del borrado por respuesta activa.
- [ ] `alertas/cu03-virustotal.json`

## CU-04 · Docker

- [ ] `cu04-docker.png`: eventos de start, stop y pause.
- [ ] `alertas/cu04-docker.json`

## CU-05 · Vulnerabilidades

- [ ] `cu05-vulnerabilidades.png`: inventario de CVE por severidad.

## Reglas personalizadas

- [ ] `reglas-logtest.png`: salida de `wazuh-logtest` con las tres fases.
- [ ] `reglas-100102.png`: alerta 100102 en *Threat Hunting*.
- [ ] `alertas/labapp-100102.json`

## Visión global

- [ ] `mitre-framework.png`: *MITRE ATT&CK → Framework* con T1110 marcada.
- [ ] `sca-puntuacion.png`: puntuación SCA (CIS) de un agente.
- [ ] `syslog-firewall.png`: eventos del firewall, si se usa.
