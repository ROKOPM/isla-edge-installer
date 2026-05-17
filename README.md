# Isla Edge Installer

Instalador minimo para el nodo distribuido `isla-edge`.

Este repositorio instala solo el nodo de captura: camara USB o RTSP, censura local, deteccion YOLO y envio al servidor central.

Para usar el pipeline completo de ISLA de Datos Urbanos, instala tambien el servidor central desde:

```text
https://github.com/ROKOPM/Isladedatos2025-2026
```

## Uso

```bash
curl -fsSL https://raw.githubusercontent.com/ROKOPM/isla-edge-installer/main/setup.sh | bash
```

Durante la instalacion se pide `FASTAPI_URL`, que debe apuntar al servidor central:

```text
http://127.0.0.1:8001/llava/          # misma PC
http://IP_DEL_SERVIDOR:8001/llava/    # otra PC por LAN o Tailscale
```

Si todavia no tienes el servidor central, primero instala `Isladedatos2025-2026` y despues instala este edge apuntando su `FASTAPI_URL` al servidor.

Si necesitas el modelo entrenado de cigarro, colocalo localmente como:

```text
keys/smoking_best.pt
```

No subas `.env`, `keys/`, `photos/` ni `hard_cases/`.
