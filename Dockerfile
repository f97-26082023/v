FROM node:lts-alpine AS dependencies
WORKDIR /home/wg
COPY ./src/package.json ./src/yarn.lock /home/wg
RUN yarn install --frozen-lockfile --production

FROM alpine:3.19 AS runner
RUN apk add --no-cache nodejs wireguard-tools
WORKDIR /home/wg
COPY --from=dependencies /home/wg/node_modules ../node_modules/
COPY src /home/wg
EXPOSE 51820/udp
EXPOSE 51821/tcp
CMD ["node", "server.js"]
