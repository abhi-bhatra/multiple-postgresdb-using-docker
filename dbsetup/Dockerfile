FROM postgres:11.5-alpine
RUN apk add --no-cache su-exec && \
    set -ex && apk --no-cache add sudo && \
    sudo echo "postgres	ALL=(ALL:ALL) ALL" >> /etc/sudoers
COPY pg-init-scripts/database.sh /docker-entrypoint-initdb.d/
