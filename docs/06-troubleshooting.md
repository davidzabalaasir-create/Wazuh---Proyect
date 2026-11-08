# 6. Registro de problemas y soluciones

Documenta aquí cada problema real que encuentres. El tribunal y las empresas valoran mucho este apartado.

## Problemas conocidos

| Síntoma | Causa probable | Solución |
|---|---|---|
| Aviso de certificado al entrar al dashboard | Certificado autofirmado | Normal: aceptar la excepción |
| *"Wazuh dashboard server is not ready yet"* | El indexer no ha arrancado (falta RAM o el disco es lento) | `sudo systemctl restart wazuh-indexer`, esperar unos 3 min y reiniciar el dashboard. Comprobar que la VM tiene 8 GB |
| No aparecen alertas | Filebeat no envía al indexer | `sudo filebeat test output` y revisar los índices `wazuh-alerts-*` |
| API caída en el dashboard | `wazuh-manager` parado | `sudo systemctl status wazuh-manager` y comprobar el puerto 55000 |
| Error de versiones | Dashboard y manager con versiones distintas | Igualar la versión mayor y la menor |
| El agente no conecta | Firewall o IP del manager incorrecta | Abrir 1514/1515 y revisar `/var/ossec/logs/ossec.log` en el agente |
| Llegan los logs de syslog pero no hay alertas | Falta el decoder o la regla, o el formato es RFC5424 | Ver la sección 3.4 |

## Plantilla para problemas propios

```markdown
### P-0X · Título breve
- **Fecha:**
- **Síntoma:**
- **Diagnóstico (comandos y logs revisados):**
- **Causa raíz:**
- **Solución:**
- **Cómo evitarlo:**
```
