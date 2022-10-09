FROM node:18-alpine

ARG REPO_DIR

EXPOSE 8080

ENV API_URL=http://localhost:8000
ENV API_WSS_URL=wss://localhost:8000

RUN apk --no-cache add \
  git \
  dumb-init

RUN addgroup -S -g 55748 kaspa-explorer \
  && adduser -h /app -S -D -g '' -G kaspa-explorer -u 55748 kaspa-explorer

WORKDIR /app
USER kaspa-explorer

COPY --chown=kaspa-explorer:kaspa-explorer "$REPO_DIR" /app

RUN npm install 

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD node server.js

