#!/bin/sh
if [ ! -f /tmp/.API_REPLACED ]; then
  find build/ -type f -name '*.js' -exec sed -i -e "s|https://kaspa.herokuapp.com|${API_URL}|g" {} \;
  find build/ -type f -name '*.js' -exec sed -i -e "s|wss://kaspa.herokuapp.com|${API_WSS_URL}|g" {} \;
  touch /tmp/.API_REPLACED
fi
exec /usr/bin/dumb-init -- "$@"

