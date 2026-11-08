# 9. Guion de la demostración (≈ 15 min)

Guion para la defensa del proyecto o para grabar el vídeo del README.

## Antes de empezar (el día anterior)

- [ ] Snapshot de todas las VMs en estado "listo para la demo".
- [ ] Inventario de vulnerabilidades ya generado (CU-05 **no** se lanza en directo).
- [ ] Dashboard abierto y con sesión iniciada; pestañas preparadas: *Agents*, *Threat Hunting*, *FIM*, *MITRE ATT&CK*.
- [ ] Terminal de Kali con el comando de Hydra escrito, sin ejecutar.
- [ ] Móvil con Telegram o Slack visible para el tribunal.
- [ ] Plan B: vídeo grabado de la demo, por si falla algo.

## Guion

| Min | Qué muestras | Qué dices (idea clave) |
|---|---|---|
| 0-2 | Diagrama de red | "Un SIEM centraliza los logs de toda la red en un único punto de análisis." |
| 2-3 | *Agents*: 2 agentes activos y sus grupos | "La configuración se gestiona por grupos: un único `agent.conf` para cada tipo de equipo." |
| 3-7 | **CU-01**: Hydra → alerta 5712 → `iptables` → segundo intento fallido → notificación en el móvil | "Detección, respuesta automática y aviso en menos de un minuto, sin intervención humana." |
| 7-9 | **CU-02**: `touch` / modificar / `rm` en `/root` → FIM | "La integridad de ficheros detecta cambios en tiempo real, incluido el contenido modificado." |
| 9-11 | **Regla propia**: `scripts/04-generate-labapp-events.sh` → alerta 100102 | "Sé crear decoders y reglas para cualquier aplicación, no solo usar las que vienen de serie." |
| 11-12 | **CU-04**: `docker run/stop` → eventos | "También vigila contenedores." |
| 12-13 | **CU-05**: inventario de CVE ya generado | "Además de detectar ataques, prioriza qué hay que parchear." |
| 13-14 | *MITRE ATT&CK* → T1110 marcada | "Cada alerta se mapea a técnicas reales de atacantes." |
| 14-15 | Informe de incidente INC-2026-001 | "Así lo documentaría un analista SOC. Lo aprendido aplica igual a Sentinel o Splunk." |

## Preguntas probables del tribunal

| Pregunta | Respuesta corta |
|---|---|
| ¿Por qué Wazuh y no Splunk o Sentinel? | Es libre, gratuito y completo (SIEM + XDR). Los conceptos (reglas, correlación, respuesta) son los mismos. |
| ¿Por qué no la versión 5.0? | Seguía en *release candidate*; ver [ADR-001](adr/ADR-001-version-wazuh.md). |
| ¿Qué pasa si cae el servidor? | Es un punto único de fallo. La mejora sería un clúster del indexer ([ADR-002](adr/ADR-002-metodo-despliegue.md)). Los agentes guardan los eventos en cola mientras tanto. |
| ¿Y los falsos positivos? | Se ajustan con reglas hijas de nivel 0 o con listas blancas (CDB lists). |
| ¿Cómo proteges el propio SIEM? | Comunicación cifrada con AES, enrolamiento con contraseña, dashboard por HTTPS y acceso solo desde la red de administración. |
