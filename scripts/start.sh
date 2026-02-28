#!/usr/bin/env bash

set -e

echo "Terraria-Backup version: $VERSION"

if [ "$STARTTRIGGER" = "1" ]; then
  /opt/terraria-backup/backup.sh
fi

echo "${CRONTIME} /opt/terraria-backup/backup.sh" > /opt/terraria-backup/crontab
# https://github.com/aptible/supercronic/issues/181
exec /usr/bin/supercronic /opt/terraria-backup/crontab

