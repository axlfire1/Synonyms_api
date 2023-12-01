#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
#rm -f /app/tmp/pids/server.pid

echo "START SYSLOG"
syslogd -n &

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
