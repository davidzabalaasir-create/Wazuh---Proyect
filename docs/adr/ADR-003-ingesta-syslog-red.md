# ADR-003: Ingesta de logs de red mediante relay rsyslog

**Estado:** Propuesto
**Fecha:** 2026-11-08
**Decisores:** David Zabala (autor)

## Contexto

El firewall del laboratorio (pfSense u OPNsense) no admite el agente de Wazuh, así que sus logs tienen que llegar por syslog. La comunidad documenta problemas al recibir syslog **RFC5424** (el formato de pfSense y FreeBSD) directamente en el manager: los mensajes llegan, pero no siempre se decodifican ni generan alertas.

## Decisión

Usar un **relay rsyslog** en `ubuntu-agent`: recibe el syslog del firewall, lo escribe en `/var/log/remote/firewall.log` y el agente lo recoge con `<localfile>`. La recepción directa en el manager queda como alternativa.

## Opciones consideradas

### Opción A: Syslog directo al manager (`<remote>` tipo syslog)

| Dimensión | Valoración |
|---|---|
| Complejidad | Baja |
| Fiabilidad de decodificación | Media-baja con RFC5424 |
| Depuración | Requiere `logall` / `archives.log` |

**Pros:** menos piezas; configuración documentada en [syslog-remote.xml](../../configs/manager/syslog-remote.xml).
**Contras:** problemas de formato y menos control sobre lo que entra.

### Opción B: Relay rsyslog en un host con agente (propuesta)

| Dimensión | Valoración |
|---|---|
| Complejidad | Media |
| Fiabilidad de decodificación | Alta: rsyslog puede normalizar el formato |
| Depuración | Sencilla: el fichero se lee con `tail -f` |

**Pros:** normaliza el formato; queda copia local en fichero; el mismo patrón sirve para cualquier dispositivo de red; se gestiona con los grupos del agente.
**Contras:** una pieza más, y si `ubuntu-agent` cae se pierden los logs de red.

## Análisis de trade-offs

La opción A es más simple, pero arriesga que el caso de uso "logs del firewall" no genere alertas el día de la defensa. La B añade una pieza que es fácil de explicar y de depurar, y además demuestra saber administrar rsyslog, una competencia de ASIR.

## Consecuencias

- ✅ Más fácil: ver y depurar los logs recibidos y añadir más dispositivos.
- ⚠️ Más difícil: hay una dependencia de `ubuntu-agent`.
- 🔁 Revisar: probar primero la opción A; si las alertas funcionan, se puede simplificar.

## Acciones

1. [ ] Probar la opción A con `logall` y `wazuh-logtest`.
2. [ ] Si falla, configurar rsyslog en `ubuntu-agent` (módulo `imudp`, puerto 514, plantilla a fichero).
3. [ ] Añadir `/var/log/remote/firewall.log` al `agent.conf` del grupo `linux`.
4. [ ] Documentar el resultado y cambiar el estado de este ADR a *Aceptado*.
