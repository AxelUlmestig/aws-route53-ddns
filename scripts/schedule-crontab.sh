#!/bin/bash

set -e

# runs every minute
#
# Explanation of why this looks so horrible:
#
# 1. Because the aws cli is installed using nix flakes and direnv, we need to call "nix-command flakes".
#
# 2. cron doesn't get the PATH variable from the normal shell. So we need to provide the full path of nix
CRON_CONFIG="* * * * * cd /home/pi/aws-route53-ddns && /nix/var/nix/profiles/default/bin/nix --extra-experimental-features \"nix-command flakes\" develop --command make refresh-route53-ip > /home/pi/aws-route53-ddns.log 2>&1"
EXISTING_CONFIG="$(crontab -l)"
LINE_BREAK=$'\n'

if echo "$EXISTING_CONFIG" | grep -cFxq "$CRON_CONFIG"; then
  echo "crontab already configured"
  exit 0
fi

echo "$EXISTING_CONFIG$LINE_BREAK$CRON_CONFIG" | crontab -
echo "crontab updated"
