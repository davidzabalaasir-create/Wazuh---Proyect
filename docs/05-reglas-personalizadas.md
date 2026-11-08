# 5. Decoder y reglas personalizadas

Objetivo: demostrar dominio del motor de análisis creando una **fuente de logs propia**, con su decoder y sus reglas.

## Escenario

Una aplicación ficticia, `labapp`, escribe en `/var/log/labapp.log` líneas como esta:

```
2026-11-08T10:15:02 labapp: LOGIN_FAILED user=admin src_ip=192.168.56.50
2026-11-08T10:15:09 labapp: LOGIN_OK user=david src_ip=192.168.56.1
```

## Ficheros

- Decoder: [configs/manager/local_decoder.xml](../configs/manager/local_decoder.xml) → `/var/ossec/etc/decoders/local_decoder.xml`
- Reglas: [configs/manager/local_rules.xml](../configs/manager/local_rules.xml) → `/var/ossec/etc/rules/local_rules.xml`

| ID | Nivel | Descripción | MITRE |
|---|---|---|---|
| 100100 | 0 | Evento base de labapp | — |
| 100101 | 5 | Login fallido en labapp | T1110 |
| 100102 | 10 | 5 logins fallidos desde la misma IP en 120 s | T1110 |
| 100103 | 3 | Login correcto en labapp | T1078 |

## Prueba con wazuh-logtest

```bash
sudo /var/ossec/bin/wazuh-logtest
```

Pega una línea de ejemplo y comprueba las tres fases:

1. **Pre-decoding:** programa `labapp`.
2. **Decoding:** campos `user` y `srcip`.
3. **Rule:** `100101`.

📸 Evidencia: salida completa de `wazuh-logtest`.

Recarga el manager:

```bash
sudo systemctl restart wazuh-manager
```

## Generar eventos reales

```bash
for i in $(seq 1 6); do
  echo "$(date +%FT%T) labapp: LOGIN_FAILED user=admin src_ip=192.168.56.50" | sudo tee -a /var/log/labapp.log
done
```

Debe aparecer la alerta **100102** (nivel 10), que también llega a Slack si está configurado.
