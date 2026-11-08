# 2. Instalación del servidor

## Versión

- **Wazuh 4.14.x** (la última estable a 08/11/2026 es la 4.14.10).
- La 5.0 sigue en *release candidate* y cambia rutas, puertos y el formato de las reglas, así que queda como trabajo futuro.

## Requisitos (1-25 agentes)

| CPU | RAM | Disco |
|---|---|---|
| 4 vCPU | 8 GB | 50 GB |

Configura una **IP estática** antes de instalar.

## Instalación todo en uno

```bash
curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh
sudo bash ./wazuh-install.sh -a
```

Al terminar, el instalador muestra:

```
INFO: You can access the web interface https://<IP>
    User: admin
    Password: <ADMIN_PASSWORD>
```

📸 **Evidencia:** captura del resumen de la instalación, con la contraseña tapada.

## Contraseñas

```bash
sudo tar -O -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt
```

Guárdalas en un gestor de contraseñas y **nunca** las subas al repositorio.

## Desactivar el repositorio (evitar actualizaciones accidentales)

```bash
sudo sed -i "s/^deb /#deb /" /etc/apt/sources.list.d/wazuh.list
sudo apt update
```

## Acceso

Abre `https://192.168.56.10` en el navegador. El aviso del certificado es normal, porque está autofirmado.

📸 **Evidencia:** pantalla de inicio del dashboard.

## Desinstalar

```bash
sudo bash ./wazuh-install.sh -u
```

## Alternativas valoradas

| Método | Ventaja | Inconveniente |
|---|---|---|
| **Script (elegido)** | Documenta el proceso real | Requiere una VM Linux |
| OVA | Lo más rápido | Oculta el proceso; credenciales por defecto `admin/admin` |
| Docker | Reproducible | Necesita `vm.max_map_count=262144`; más difícil de depurar |
