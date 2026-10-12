#!/usr/bin/env bash
# Starr config backup via restic.
#
# Bootstrap (once):
#   docker compose run --rm backup restic init
# Manual run:
#   docker compose run --rm backup /scripts/run-backup.sh
# Enable daily cron:
#   docker compose up -d backup
#
# Optional SFTP second repo: set BACKUP_SFTP_REPO (and mount an SSH key), then:
#   docker compose run --rm -e RESTIC_REPOSITORY="$BACKUP_SFTP_REPO" backup restic init

set -euo pipefail

RESTIC_REPOSITORY="${RESTIC_REPOSITORY:-/repo}"
EXCLUDE_FILE="${EXCLUDE_FILE:-/scripts/excludes.txt}"
COMPOSE_DIR="${COMPOSE_DIR:-/sources/starr}"
DISCORD_WEBHOOK="${DISCORD_WEBHOOK:-}"

# Compose service names (stateful / SQLite or DB writers)
STATEFUL_SERVICES=(
  jellyfin
  radarr
  sonarr
  prowlarr
  qbittorrent
  jellyseerr
  bazarr
  kapowarr
  gotify
  jfa-go
  qui
  tracearr
  timescale
  redis
)

notify_fail() {
  local msg="$1"
  echo "backup ERROR: ${msg}" >&2
  if [[ -n "${DISCORD_WEBHOOK}" ]]; then
    local escaped
    escaped=$(printf '%s' "Starr backup failed: ${msg}" | sed 's/\\/\\\\/g; s/"/\\"/g')
    curl -fsS -H "Content-Type: application/json" \
      -d "{\"content\":\"${escaped}\"}" \
      "${DISCORD_WEBHOOK}" >/dev/null 2>&1 || true
  fi
}

compose() {
  docker compose --project-directory "${COMPOSE_DIR}" "$@"
}

STOPPED_SERVICES=()

stop_stateful() {
  echo "backup: stopping stateful services..."
  local existing=()
  local svc
  local available
  available="$(compose ps -a --services 2>/dev/null || true)"
  for svc in "${STATEFUL_SERVICES[@]}"; do
    if printf '%s\n' "${available}" | grep -qx "${svc}"; then
      existing+=("${svc}")
    fi
  done
  if ((${#existing[@]} > 0)); then
    compose stop "${existing[@]}"
  else
    echo "backup: no stateful services found to stop"
  fi
  STOPPED_SERVICES=("${existing[@]}")
}

start_stateful() {
  if ((${#STOPPED_SERVICES[@]} == 0)); then
    return 0
  fi
  echo "backup: starting services: ${STOPPED_SERVICES[*]}"
  compose start "${STOPPED_SERVICES[@]}" || true
}

trap start_stateful EXIT

if [[ -z "${RESTIC_PASSWORD:-}" ]]; then
  notify_fail "RESTIC_PASSWORD is not set"
  exit 1
fi

if [[ ! -d "${RESTIC_REPOSITORY}" ]] && [[ ! -e "${RESTIC_REPOSITORY}" ]]; then
  notify_fail "repository path ${RESTIC_REPOSITORY} does not exist (mount /backup?)"
  exit 1
fi

if ! restic -r "${RESTIC_REPOSITORY}" snapshots >/dev/null 2>&1; then
  notify_fail "restic repository not initialized — run: docker compose run --rm backup restic init"
  exit 1
fi

echo "backup: starting at $(date -Iseconds)"
stop_stateful

BACKUP_PATHS=(/sources/appdata)
[[ -f /sources/starr/.env ]] && BACKUP_PATHS+=(/sources/starr/.env)
[[ -d /sources/starr/compose/config ]] && BACKUP_PATHS+=(/sources/starr/compose/config)

echo "backup: restic backup ${BACKUP_PATHS[*]}"
restic -r "${RESTIC_REPOSITORY}" backup \
  "${BACKUP_PATHS[@]}" \
  --exclude-file="${EXCLUDE_FILE}" \
  --tag starr \
  --host starr

# Restart apps before prune/copy so downtime stays short
start_stateful
trap - EXIT

echo "backup: forget + prune"
restic -r "${RESTIC_REPOSITORY}" forget \
  --tag starr \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 6 \
  --prune

if [[ -n "${BACKUP_SFTP_REPO:-}" ]]; then
  echo "backup: copying snapshots to SFTP repo ${BACKUP_SFTP_REPO}"
  export RESTIC_PASSWORD2="${RESTIC_PASSWORD2:-$RESTIC_PASSWORD}"
  COPY_OPTS=()
  if [[ -n "${BACKUP_SFTP_KEY_FILE:-}" ]]; then
    COPY_OPTS+=(-o "sftp.args=-i ${BACKUP_SFTP_KEY_FILE} -o StrictHostKeyChecking=accept-new")
  fi
  restic -r "${RESTIC_REPOSITORY}" "${COPY_OPTS[@]}" copy --repo2 "${BACKUP_SFTP_REPO}"
fi

echo "backup: completed successfully at $(date -Iseconds)"
