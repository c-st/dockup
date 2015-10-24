#!/bin/sh
set -e

if [[ "$RESTORE" == "true" ]]; then
  /etc/scripts/restore.sh
fi

if [[ ${BACKUP_TIMEZONE} ]]; then
  # See http://wiki.alpinelinux.org/wiki/Setting_the_timezone
  cp /usr/share/zoneinfo/${BACKUP_TIMEZONE} /etc/localtime
  echo "${BACKUP_TIMEZONE}" >  /etc/timezone
fi

echo "${BACKUP_CRON_SCHEDULE} /etc/scripts/backup.sh" > /etc/crontabs/root

# Start cron
crond -f -d 8
