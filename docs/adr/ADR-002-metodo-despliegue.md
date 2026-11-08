# ADR-002: Despliegue todo en uno con el script oficial

**Estado:** Aceptado
**Fecha:** 2026-11-08
**Decisores:** David Zabala (autor) · tutor del proyecto

## Contexto

- **Hardware:** un portátil o PC con unos 16 GB de RAM, donde también tienen que funcionar los endpoints (Ubuntu, Windows) y la máquina atacante.
- **Escala:** menos de 10 agentes, con una retención corta de 7 a 14 días.
- **Requisito académico:** el proceso de instalación tiene que poder **mostrarse y documentarse**.
- **Requisito oficial para 1-25 agentes:** 4 vCPU, 8 GB de RAM y 50 GB de disco.

## Decisión

Instalar **manager, indexer y dashboard en una única VM Ubuntu Server 24.04** con el asistente oficial `wazuh-install.sh -a`.

## Opciones consideradas

### Opción A: Todo en uno con script (elegida)

| Dimensión | Valoración |
|---|---|
| Complejidad | Baja |
| Recursos | 8 GB (1 VM) |
| Escalabilidad | Hasta unos 25 agentes |
| Valor didáctico | Alto: se ve y se documenta cada componente |

**Pros:** un solo comando; servicios systemd reales que se pueden diagnosticar; es el método de la guía oficial.
**Contras:** un único punto de fallo y ninguna alta disponibilidad.

### Opción B: OVA oficial

| Dimensión | Valoración |
|---|---|
| Complejidad | Muy baja |
| Recursos | 8 GB |
| Escalabilidad | Igual que A |
| Valor didáctico | Bajo |

**Pros:** lo más rápido de poner en marcha.
**Contras:** oculta la instalación, usa Amazon Linux en lugar del sistema elegido y trae credenciales `admin/admin` iguales en todas las copias.

### Opción C: Docker (single-node)

| Dimensión | Valoración |
|---|---|
| Complejidad | Media |
| Recursos | 8 GB + motor Docker |
| Escalabilidad | Igual que A |
| Valor didáctico | Medio |

**Pros:** reproducible, se monta y se desmonta rápido.
**Contras:** necesita `vm.max_map_count=262144`; los certificados y volúmenes son más difíciles de depurar; mezcla dos tecnologías en un proyecto centrado en SIEM.

### Opción D: Distribuido (indexer, manager y dashboard en VMs separadas)

| Dimensión | Valoración |
|---|---|
| Complejidad | Alta |
| Recursos | Más de 16 GB |
| Escalabilidad | Alta |
| Valor didáctico | Alto, pero fuera de alcance |

**Pros:** es lo más parecido a producción y permite trabajar la alta disponibilidad.
**Contras:** no cabe en el hardware disponible junto con los endpoints.

## Análisis de trade-offs

A da el mejor equilibrio entre recursos y valor didáctico. B ahorra tiempo pero resta nota. C añade complejidad que no aporta al objetivo. D sería ideal para SAD (alta disponibilidad), pero el hardware no lo permite: queda como mejora futura.

## Consecuencias

- ✅ Más fácil: instalar, hacer copias de la VM con snapshots y diagnosticar problemas.
- ⚠️ Más difícil: demostrar alta disponibilidad, porque hay un único punto de fallo.
- 🔁 Revisar: si se dispone de más RAM, añadir un segundo nodo del indexer.

## Acciones

1. [ ] Crear la VM con una IP estática (`192.168.56.10`).
2. [ ] Hacer un snapshot **antes** y **después** de la instalación.
3. [ ] Ejecutar [`scripts/01-install-server.sh`](../../scripts/01-install-server.sh).
4. [ ] Documentar en [06-troubleshooting](../06-troubleshooting.md) cualquier incidencia.
