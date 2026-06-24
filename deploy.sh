#!/usr/bin/env bash
#
# Pull the latest code and restart the app server.
#
# Usage:
#   ./deploy.sh
#
# This project is served by gunicorn under the systemd unit `nebius.service`
# (despite the "uwsgi" name some deploy notes use). The script fetches the
# latest commit on the current branch, then restarts that unit so the new
# code is picked up.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE="${SERVICE:-nebius.service}"

cd "$SCRIPT_DIR"

echo "Pulling latest code in $SCRIPT_DIR ..."
git pull

echo "Restarting $SERVICE ..."
sudo systemctl restart "$SERVICE"

echo "Done. Current status:"
sudo systemctl --no-pager --lines=0 status "$SERVICE"
