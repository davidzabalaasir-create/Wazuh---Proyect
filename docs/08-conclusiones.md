# 8. Conclusiones y trabajo futuro

## Conclusiones

> Rellena esta sección al terminar el laboratorio. Algunas preguntas guía:

- ¿Qué aporta centralizar los logs frente a revisarlos máquina por máquina?
- ¿Qué caso de uso fue más difícil y por qué?
- ¿Qué falsos positivos aparecieron y cómo se ajustaron?
- ¿Qué cambiarías en un entorno de producción real?

## Trabajo futuro

- **Migración a Wazuh 5.0**, cuando salga la versión definitiva: nuevas rutas (`/var/wazuh-manager`), enrolamiento por el puerto 1517 y reglas en **YAML** de estilo Sigma. Comparar la misma regla de [05-reglas-personalizadas](05-reglas-personalizadas.md) en XML 4.x y en YAML 5.0.
- **Suricata** como IDS de red, integrado con Wazuh.
- **Reglas YARA** para detectar malware.
- **Alta disponibilidad:** clúster del indexer o copias de seguridad y restauración.
- **Notificaciones** por Telegram o Discord con scripts de integración propios.
- **Hardening CIS** guiado por los resultados de SCA.
