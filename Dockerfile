FROM node:lts-alpine AS builder
WORKDIR /app
COPY src/ /app/

FROM node:lts-alpine AS dependencies
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --production

FROM alpine:3.17 AS runner
RUN apk add --update --no-cache nodejs wireguard-tools dumb-init
WORKDIR /app
COPY --from=dependencies /node_modules/ /app/node_modules
COPY --from=builder /app /app
EXPOSE 51820/udp
EXPOSE 51821/tcp
ENV DEBUG=Server,WireGuard
CMD ["/usr/bin/dumb-init", "node", "server.js"]
