#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
#rm -f /app/tmp/pids/server.pid

echo "START SYSLOG"
syslogd -n &

echo "SETTING WHENEVER CRON TASK"
bundle exec whenever --set 'environment=production' --update-crontab && crond -b 

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
