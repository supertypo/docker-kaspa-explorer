#!/bin/sh
if [ ! -f /tmp/.API_REPLACED ]; then
  find /app/ -name node_modules -prune -o -type f -exec sed -i "s|https://kaspa.herokuapp.com|${API_URI}|g" {} \;
  find /app/ -name node_modules -prune -o -type f -exec sed -i "s|wss://kaspa.herokuapp.com|${API_WS_URI}|g" {} \;
  touch /tmp/.API_REPLACED
fi
exec /usr/bin/dumb-init -- "$@"

