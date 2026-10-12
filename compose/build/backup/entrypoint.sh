#!/usr/bin/env bash
set -euo pipefail

export RESTIC_REPOSITORY="${RESTIC_REPOSITORY:-/repo}"

# Allow one-shot commands: docker compose run --rm backup restic init
if [[ $# -gt 0 ]]; then
  exec "$@"
fi

CRON="${BACKUP_CRON:-0 3 * * *}"
# Redirect job output to container logs
echo "${CRON} /scripts/run-backup.sh" > /tmp/crontab

echo "backup: scheduling restic with cron '${CRON}'"
exec supercronic -passthrough-logs /tmp/crontab
