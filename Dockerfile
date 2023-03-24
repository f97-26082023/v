FROM node:lts-alpine AS dependencies
WORKDIR /home/wg
COPY ./src/package.json ./src/package-lock.json /home/wg
RUN npm ci --production

FROM alpine:3.17.2 AS runner
RUN apk add --no-cache nodejs wireguard-tools
WORKDIR /home/wg
COPY --from=dependencies /home/wg/node_modules ../node_modules/
COPY src /home/wg
EXPOSE 51820/udp
EXPOSE 51821/tcp
ENV DEBUG=Server,WireGuard
CMD ["node", "server.js"]
