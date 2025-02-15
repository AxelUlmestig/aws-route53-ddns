#!/bin/bash

set -e

# run every minute
CRON_CONFIG="* * * * * cd $PWD && make refresh-route53-ip"
EXISTING_CONFIG="$(crontab -l)"

if echo "$EXISTING_CONFIG" | grep -cFxq "$CRON_CONFIG"; then
  echo "crontab already configured"
  exit 0
fi

echo "$CRON_CONFIG" | crontab -
echo "crontab updated"
