#!/usr/bin/env bash

echo "Terraria-Backup version: $VERSION"

if [ "$STARTTRIGGER" = "1" ]; then
  /opt/terraria-backup/backup.sh
fi

(crontab -l 2>/dev/null; echo "${CRONTIME} /opt/terraria-backup/backup.sh") | crontab -
crond -f
