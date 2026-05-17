# Isla Edge Installer

Instalador minimo para el nodo distribuido `isla-edge`.

## Uso

```bash
curl -fsSL https://raw.githubusercontent.com/ROKOPM/isla-edge-installer/main/setup.sh | bash
```

Durante la instalacion se pide `FASTAPI_URL`, que debe apuntar al servidor central:

```text
http://127.0.0.1:8001/llava/          # misma PC
http://IP_DEL_SERVIDOR:8001/llava/    # otra PC por LAN o Tailscale
```

Si necesitas el modelo entrenado de cigarro, colocalo localmente como:

```text
keys/smoking_best.pt
```

No subas `.env`, `keys/`, `photos/` ni `hard_cases/`.
