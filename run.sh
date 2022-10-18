#!/bin/sh
docker run --rm -it -p 8080:8080 -e "API_URL=http://192.168.168.2:8000" -e "API_WSS_URL=ws://192.168.168.2:8000" supertypo/kaspa-explorer

