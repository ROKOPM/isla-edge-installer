#!/usr/bin/env bash
set -Eeuo pipefail

DEFAULT_REPO_URL="${ISLA_EDGE_INSTALLER_REPO_URL:-https://github.com/ROKOPM/isla-edge-installer.git}"
DEFAULT_INSTALL_DIR="${ISLA_EDGE_INSTALL_DIR:-$HOME/isla-edge}"

need_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Error: falta '$1'." >&2
    exit 1
  fi
}

random_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -base64 48 | tr -d '\n'
  else
    date +%s%N | sha256sum | awk '{print $1}'
  fi
}

prompt() {
  local label="$1"
  local default="${2:-}"
  local value
  local input="/dev/stdin"
  if [[ -r /dev/tty ]]; then
    input="/dev/tty"
  fi
  if [[ -n "$default" ]]; then
    read -r -p "${label} [${default}]: " value <"$input"
    echo "${value:-$default}"
  else
    read -r -p "${label}: " value <"$input"
    echo "$value"
  fi
}

replace_env() {
  local key="$1"
  local value="$2"
  local escaped
  escaped="$(printf '%s' "$value" | sed 's/[\/&]/\\&/g')"
  sed -i "s/^${key}=.*/${key}=${escaped}/" .env
}

need_command docker
need_command git

if ! docker compose version >/dev/null 2>&1; then
  echo "Error: Docker Compose v2 no esta disponible. Instala el plugin 'docker compose'." >&2
  exit 1
fi

if [[ ! -e /dev/video0 ]]; then
  echo "Aviso: no se detecto /dev/video0. Si usaras solo RTSP, activa RTSP_ENABLED=true."
fi

repo_url="$(prompt "Repositorio installer edge" "$DEFAULT_REPO_URL")"
install_dir="$(prompt "Directorio de instalacion" "$DEFAULT_INSTALL_DIR")"

if [[ -d "$install_dir/.git" ]]; then
  git -C "$install_dir" pull --ff-only
else
  git clone "$repo_url" "$install_dir"
fi

cd "$install_dir"

if [[ ! -f .env ]]; then
  cp .env.template .env
fi

mkdir -p photos hard_cases keys

replace_env GHCR_OWNER "rokopm"
replace_env IMAGE_TAG "${IMAGE_TAG:-latest}"
replace_env FLASK_SECRET_KEY "$(random_secret)"

server_url="$(prompt "URL del servidor central /llava/" "$(grep -E '^FASTAPI_URL=' .env | cut -d= -f2-)")"
replace_env FASTAPI_URL "$server_url"

rtsp_enabled="$(prompt "Activar RTSP true/false" "$(grep -E '^RTSP_ENABLED=' .env | cut -d= -f2-)")"
replace_env RTSP_ENABLED "$rtsp_enabled"

if [[ "$rtsp_enabled" =~ ^(true|1|yes)$ ]]; then
  replace_env RTSP_USER "$(prompt "RTSP usuario" "$(grep -E '^RTSP_USER=' .env | cut -d= -f2-)")"
  replace_env RTSP_PASS "$(prompt "RTSP password" "$(grep -E '^RTSP_PASS=' .env | cut -d= -f2-)")"
  replace_env RTSP_HOST "$(prompt "RTSP host" "$(grep -E '^RTSP_HOST=' .env | cut -d= -f2-)")"
  replace_env RTSP_PARAMS "$(prompt "RTSP params" "$(grep -E '^RTSP_PARAMS=' .env | cut -d= -f2-)")"
fi

if ! docker compose pull; then
  cat >&2 <<'EOF'

Error: no se pudo descargar ghcr.io/rokopm/isla-edge.

Si el paquete GHCR es privado, inicia sesion:

  echo TU_TOKEN | docker login ghcr.io -u ROKOPM --password-stdin

El token necesita permiso read:packages.
EOF
  exit 1
fi

docker compose up -d

echo
echo "Nodo edge levantando."
echo "Interfaz local: http://localhost:5000"
echo
echo "Comandos utiles:"
echo "  docker compose ps"
echo "  docker compose logs -f edge"
echo "  docker compose down"
