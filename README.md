# Isla Edge Installer

Instalador minimo para el nodo distribuido `isla-edge`.

Este repositorio instala solo el nodo de captura: camara USB o RTSP, censura local, deteccion YOLO y envio al servidor central.

Codigo fuente y explicacion del proyecto:

```text
https://github.com/ROKOPM/Isladedatos2025-2026
```

Para usar el pipeline completo de ISLA de Datos Urbanos, instala tambien el servidor central desde:

```text
https://github.com/ROKOPM/isla-installer
```

## Instalacion en Linux

```bash
curl -fsSL https://raw.githubusercontent.com/ROKOPM/isla-edge-installer/main/setup.sh | bash
```

Durante la instalacion se pide `FASTAPI_URL`, que debe apuntar al servidor central:

```text
http://127.0.0.1:8001/llava/          # misma PC
http://IP_DEL_SERVIDOR:8001/llava/    # otra PC por LAN o Tailscale
```

Si todavia no tienes el servidor central, primero instala `isla-installer` y despues instala este edge apuntando su `FASTAPI_URL` al servidor.

## Instalacion en Windows

Requisitos:

- Windows 10/11
- Docker Desktop con backend WSL2
- Git for Windows
- PowerShell
- Camara compatible con WSL2 o camara RTSP accesible por red

Opcion recomendada: instalar desde WSL2 Ubuntu:

```powershell
wsl --install -d Ubuntu
```

Abrir Ubuntu y ejecutar:

```bash
curl -fsSL https://raw.githubusercontent.com/ROKOPM/isla-edge-installer/main/setup.sh | bash
```

Opcion PowerShell, usando Git Bash instalado con Git for Windows:

```powershell
bash -lc "curl -fsSL https://raw.githubusercontent.com/ROKOPM/isla-edge-installer/main/setup.sh | bash"
```

En Windows suele ser mas estable usar camara RTSP que mapear `/dev/video0` desde WSL2.

Si necesitas el modelo entrenado de cigarro, colocalo localmente como:

```text
keys/smoking_best.pt
```

No subas `.env`, `keys/`, `photos/` ni `hard_cases/`.
