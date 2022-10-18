FROM node:18-alpine AS builder

ARG REPO_DIR
ARG TAG

RUN apk --no-cache add \
  git

COPY "$REPO_DIR" /build

ENV REACT_APP_VERCEL_GIT_COMMIT_SHA="$TAG"

RUN cd /build \
  && npm install


FROM node:18-alpine

EXPOSE 8080

ENV API_URL=http://localhost:8000 \
  API_WS_URL=wss://localhost:8000

RUN apk --no-cache add \
  dumb-init

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh

RUN addgroup -S -g 55748 kaspa-explorer \
  && adduser -h /app -S -D -g '' -G kaspa-explorer -u 55748 kaspa-explorer

WORKDIR /app
USER kaspa-explorer

COPY --from=builder --chown=kaspa-explorer:kaspa-explorer /build/*.js /app/
COPY --from=builder --chown=kaspa-explorer:kaspa-explorer /build/build /app/build
COPY --from=builder --chown=kaspa-explorer:kaspa-explorer /build/node_modules /app/node_modules

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD node server.js

