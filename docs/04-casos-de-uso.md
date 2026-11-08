# 4. Casos de uso

Todos los casos siguen la misma plantilla:

> **Objetivo · MITRE · Configuración · Disparador · Regla esperada · Evidencia · Respuesta · Lección aprendida**

Los IDs de regla y las técnicas MITRE **se confirman con la alerta real**, a partir de los campos `rule.id` y `rule.mitre.id` del JSON. Guarda cada JSON en [`../evidencias/alertas/`](../evidencias/alertas/).

---

## CU-01 · Fuerza bruta SSH + respuesta activa

| Campo | Valor |
|---|---|
| Objetivo | Detectar un ataque de diccionario por SSH y bloquear al atacante automáticamente |
| MITRE | T1110 – Brute Force |
| Configuración | [configs/manager/active-response.xml](../configs/manager/active-response.xml) |
| Reglas esperadas | 5551, 5712 (detección) · 5763 (dispara la respuesta activa) |

**Preparación (solo laboratorio):** en ubuntu-agent, habilita la autenticación por contraseña con `/etc/ssh/sshd_config.d/00-poc-password-auth.conf`:

```
PasswordAuthentication yes
```

```bash
sudo systemctl restart ssh
```

**Disparador (kali-attacker):**

```bash
hydra -l badguy -P /usr/share/wordlists/rockyou.txt 192.168.56.20 ssh -t 4
```

**Comprobación en la víctima:**

```bash
sudo iptables -L -n | grep 192.168.56.50
```

La IP queda bloqueada durante 180 s, y un segundo intento de Hydra falla.

📸 Evidencias: Threat Hunting filtrado por `rule.id:5712`, salida de `iptables` y MITRE Framework con T1110 marcada.

**Limpieza:** borra `00-poc-password-auth.conf` y reinicia SSH.

---

## CU-02 · Integridad de ficheros (FIM)

| Campo | Valor |
|---|---|
| Objetivo | Detectar en tiempo real la creación, modificación y borrado de ficheros críticos |
| Configuración | `<syscheck>` en [configs/shared/linux/agent.conf](../configs/shared/linux/agent.conf) |
| Reglas esperadas | 554 (añadido) · 550 (modificado) · 553 (borrado) |

**Disparador:**

```bash
sudo touch /root/prueba-fim.txt
echo "cambio" | sudo tee -a /root/prueba-fim.txt
sudo rm /root/prueba-fim.txt
```

📸 Evidencia: módulo *File Integrity Monitoring* → Events.

---

## CU-03 · Malware con VirusTotal + borrado automático

| Campo | Valor |
|---|---|
| Objetivo | Analizar con VirusTotal los ficheros nuevos y borrar los maliciosos |
| Requisitos | Clave API gratuita de VirusTotal, `jq` en el agente y script `remove-threat.sh` (750, `root:wazuh`) |
| Reglas esperadas | 100200 / 100201 (locales, según la guía PoC) |

**Disparador (fichero de prueba EICAR, inofensivo):**

```bash
sudo curl -s -o /root/eicar.com https://secure.eicar.org/eicar.com
```

Sigue la guía oficial *Detecting and removing malware using VirusTotal integration* para los bloques de configuración.

> 🔐 La clave API **no se sube** al repositorio: sustitúyela por `TU_API_KEY`.

---

## CU-04 · Monitorización de Docker

| Campo | Valor |
|---|---|
| Objetivo | Registrar la actividad de los contenedores |
| Configuración | Módulo `docker-listener` en [configs/shared/linux/agent.conf](../configs/shared/linux/agent.conf) |
| Reglas esperadas | 87903-87906 (por confirmar en 4.14) |

```bash
docker run -d --name prueba nginx
docker pause prueba && docker unpause prueba
docker stop prueba && docker rm prueba
```

---

## CU-05 · Detección de vulnerabilidades

| Campo | Valor |
|---|---|
| Objetivo | Inventariar los CVE de los endpoints |
| Nota | Deja tiempo a que se descarguen los feeds. **En la defensa, muestra el inventario ya generado**: no lo lances en directo |

📸 Evidencia: módulo *Vulnerability Detection* con los CVE por severidad.

---

## Extra · Notificaciones en el móvil

| Canal | Tipo | Configuración |
|---|---|---|
| Slack | Integración nativa | [integration-slack.xml](../configs/manager/integration-slack.xml) |
| Telegram | Script personalizado | [integration-telegram.xml](../configs/manager/integration-telegram.xml) + [custom-telegram](../configs/integrations/custom-telegram) |

Instalación de Telegram en el manager:

```bash
sudo cp configs/integrations/custom-telegram /var/ossec/integrations/
sudo chown root:wazuh /var/ossec/integrations/custom-telegram
sudo chmod 750 /var/ossec/integrations/custom-telegram
# añade el bloque <integration> a ossec.conf con tu token y tu chat_id
sudo systemctl restart wazuh-manager
tail -f /var/ossec/logs/integrations.log
```

Ambas envían las alertas de nivel ≥ 10, así que el CU-01 debería hacer sonar el móvil. **No** subas tokens ni *webhooks* al repositorio.

## Tabla resumen (rellena con datos reales)

| CU | rule.id | rule.mitre.id | Nivel | Fecha/hora | Captura |
|---|---|---|---|---|---|
| 01 | | | | | |
| 02 | | | | | |
| 03 | | | | | |
| 04 | | | | | |
| 05 | | | | | |
