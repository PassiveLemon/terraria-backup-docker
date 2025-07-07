#!/bin/sh

set -e

# Create backup user for rootless operation
if ! getent group backup > /dev/null 2>&1; then
  addgroup -g "$PGID" backup
fi
if ! getent passwd backup > /dev/null 2>&1; then
  adduser -u "$PUID" -G backup -s /bin/sh -D backup
fi
chown -R "$PUID:$PGID" /opt/terraria-backup

exec su-exec "$PUID:$PGID" "/opt/terraria-backup/start.sh"

