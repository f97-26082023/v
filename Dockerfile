FROM node:lts-alpine AS dependencies
WORKDIR /home/wg
COPY package.json package-lock.json /home/wg
RUN npm ci --production

FROM alpine:3.17 AS runner
RUN apk add --update --no-cache nodejs wireguard-tools dumb-init
WORKDIR /home/wg
COPY --from=dependencies /home/wg/node_modules ../node_modules/
COPY src /home/wg
EXPOSE 51820/udp
EXPOSE 51821/tcp
ENV DEBUG=Server,WireGuard
CMD ["/usr/bin/dumb-init", "node", "server.js"]
