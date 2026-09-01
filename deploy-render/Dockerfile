# Combined image for Render: nginx (frontend + proxy) and the Node API
# run together in ONE container, because Render runs a single container
# per web service (unlike docker-compose's separate web/api containers).

FROM --platform=$BUILDPLATFORM node:22-alpine AS build
WORKDIR /app
COPY frontend/package.json frontend/package-lock.json* ./
RUN npm ci 2>/dev/null || npm install
COPY frontend/ ./
RUN npm run build

FROM alpine/git AS media
RUN mkdir -p /out/img /out/gif && \
    git clone --depth 1 https://github.com/hasaneyldrm/exercises-dataset /tmp/ds && \
    cp /tmp/ds/images/*.jpg /out/img/ && \
    cp /tmp/ds/videos/*.gif /out/gif/

FROM node:22-alpine
RUN apk add --no-cache nginx

WORKDIR /app/api
COPY api/package.json api/package-lock.json* ./
RUN npm install --omit=dev && npm cache clean --force
COPY api/server.js ./

RUN mkdir -p /data

COPY --from=build /app/dist /usr/share/nginx/html
COPY --from=media /out/img /usr/share/nginx/html/img
COPY --from=media /out/gif /usr/share/nginx/html/gif

COPY deploy-render/nginx.conf /etc/nginx/http.d/default.conf
COPY deploy-render/start.sh /start.sh
RUN chmod +x /start.sh

ENV DATA_DIR=/data
EXPOSE 8080

CMD ["/start.sh"]
