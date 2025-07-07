FROM docker.io/alpine:latest
# VERSION comes from the main.yml workflow --build-arg
ARG VERSION

RUN apk add --no-cache su-exec bash supercronic tar gzip zip 7zip

RUN mkdir -p /opt/terraria-backup/worlds/

COPY entrypoint.sh /opt/terraria-backup/
COPY backup.sh /opt/terraria-backup/
COPY start.sh /opt/terraria-backup/

RUN chmod -R 755 /opt/terraria-backup/ &&\
    chmod +x /opt/terraria-backup/entrypoint.sh &&\
    chmod +x /opt/terraria-backup/backup.sh &&\
    chmod +x /opt/terraria-backup/start.sh

WORKDIR /opt/terraria-backup/

ENV PUID="1000"
ENV PGID="1000"

ENV VERSION=$VERSION

ENV CRONTIME="0 1 * * *"
ENV STARTTRIGGER="0"
ENV METHOD="cp"
ENV ROTATIONS="5"

ENTRYPOINT ["/opt/terraria-backup/entrypoint.sh"]

