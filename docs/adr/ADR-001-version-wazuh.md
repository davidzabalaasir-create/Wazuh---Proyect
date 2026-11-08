# ADR-001: Usar Wazuh 4.14.x en lugar de 5.0

**Estado:** Aceptado
**Fecha:** 2026-11-08
**Decisores:** David Zabala (autor) · tutor del proyecto

## Contexto

El laboratorio tiene que ser estable y reproducible, y hay que poder documentarlo durante el curso. A fecha de 08/11/2026:

- **4.14.10** es la última versión estable (publicada el 05/11/2026) y la que instala la documentación "current".
- **5.0** solo está como *release candidate* en un repositorio *staging* y no tiene versión definitiva anunciada.
- La 5.0 cambia rutas (`/var/wazuh-manager`), puertos (enrolamiento por 1517/HTTPS), índices y el formato de las reglas (de XML a YAML de estilo Sigma).
- No se puede actualizar directamente de 4.x a 5.0.

## Decisión

Construir todo el proyecto sobre **Wazuh 4.14.x**, fijar la versión exacta en la memoria y dejar la 5.0 como *trabajo futuro*.

## Opciones consideradas

### Opción A: Wazuh 4.14.x (elegida)

| Dimensión | Valoración |
|---|---|
| Complejidad | Baja |
| Estabilidad | Alta (versión GA) |
| Documentación y comunidad | Amplia: guía PoC, foros, tutoriales |
| Vigencia | Media: la 5.0 la sustituirá |

**Pros:** guía oficial PoC compatible, IDs de regla conocidos, mucha ayuda disponible cuando algo falla.
**Contras:** parte de lo aprendido sobre reglas XML y rutas cambiará con la 5.0.

### Opción B: Wazuh 5.0 RC

| Dimensión | Valoración |
|---|---|
| Complejidad | Alta |
| Estabilidad | Baja (pre-release) |
| Documentación y comunidad | Escasa, en desarrollo |
| Vigencia | Alta |

**Pros:** tecnología más nueva; las reglas YAML se parecen más a los SIEM comerciales.
**Contras:** la documentación puede cambiar en pleno curso y casi no hay ayuda de la comunidad. Una defensa sobre software inestable es un riesgo.

## Análisis de trade-offs

Un proyecto académico se evalúa por si funciona y si se puede demostrar. La 4.14 da previsibilidad a cambio de quedarse algo atrás. Ese desfase se compensa con un apartado que compare la misma regla en XML 4.x y en YAML 5.0, que además es un punto original del proyecto.

## Consecuencias

- ✅ Más fácil: seguir la guía oficial y resolver problemas.
- ⚠️ Más difícil: reutilizar las configuraciones en 5.0 sin adaptarlas.
- 🔁 Revisar: cuando salga la 5.0 GA, valorar una pila paralela de pruebas.

## Acciones

1. [ ] Anotar la versión exacta instalada (`/var/ossec/bin/wazuh-control info`).
2. [ ] Desactivar el repositorio APT tras la instalación.
3. [ ] Escribir la sección "Migración a 5.0" en [08-conclusiones](../08-conclusiones.md).
