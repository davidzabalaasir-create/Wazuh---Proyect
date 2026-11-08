# 3. Agentes y centralización de logs

La "centralización" del proyecto se basa en **grupos de agentes**. Cada grupo tiene un `agent.conf` que el manager envía automáticamente a todos sus agentes.

## 3.1 Crear grupos

```bash
sudo /var/ossec/bin/agent_groups -a -g linux -q
sudo /var/ossec/bin/agent_groups -a -g windows -q
sudo /var/ossec/bin/agent_groups -a -g web -q
```

O usa el script [`scripts/02-create-groups.sh`](../scripts/02-create-groups.sh).

Configuración compartida:

- `/var/ossec/etc/shared/linux/agent.conf` → [configs/shared/linux/agent.conf](../configs/shared/linux/agent.conf)
- `/var/ossec/etc/shared/windows/agent.conf` → [configs/shared/windows/agent.conf](../configs/shared/windows/agent.conf)

Valida la sintaxis antes de aplicar:

```bash
sudo /var/ossec/bin/verify-agent-conf
```

## 3.2 Agente Linux (Ubuntu)

Añade primero el repositorio de Wazuh siguiendo la documentación oficial. Después:

```bash
sudo WAZUH_MANAGER="192.168.56.10" WAZUH_AGENT_GROUP="linux,web" \
     WAZUH_AGENT_NAME="ubuntu-agent" apt-get install wazuh-agent
sudo systemctl daemon-reload
sudo systemctl enable --now wazuh-agent
```

## 3.3 Agente Windows

En el dashboard: **Agents → Deploy new agent → Windows**. Indica la IP del servidor y el grupo `windows`, y ejecuta en PowerShell (como administrador) el comando que te genera.

### Sysmon

```powershell
.\Sysmon64.exe -accepteula -i sysmonconfig.xml
```

Usa una configuración de referencia de la comunidad, por ejemplo la de SwiftOnSecurity. El canal `Microsoft-Windows-Sysmon/Operational` se recoge desde el `agent.conf` del grupo `windows`.

📸 **Evidencia:** vista *Agents* con los dos agentes **Active**.

## 3.4 Syslog desde el firewall (opcional)

Añade al `ossec.conf` del manager el bloque de [configs/manager/syslog-remote.xml](../configs/manager/syslog-remote.xml), **sin borrar** el bloque `<remote>` de tipo `secure`.

Para comprobar que llegan los mensajes:

1. Activa temporalmente `<logall>yes</logall>` en `ossec.conf`.
2. Busca la IP del firewall en `/var/ossec/logs/archives/archives.log`.
3. Vuelve a desactivar `logall` para no llenar el disco.

> ⚠️ Recibir logs no basta para tener alertas: hacen falta decoders y reglas que reconozcan esos mensajes. pfSense usa el formato RFC5424, que puede dar problemas. Una alternativa más robusta es recibir el syslog con rsyslog en un host con agente y leer el fichero con `<localfile>`.

## 3.5 Retención

Crea una política ISM en **Indexer management → Index Management → State management policies** que borre los índices `wazuh-alerts-*` pasados **14 días**, una cifra razonable para un disco de 50 GB. La política solo se aplica sola a los índices nuevos: a los que ya existen hay que aplicarla a mano.
