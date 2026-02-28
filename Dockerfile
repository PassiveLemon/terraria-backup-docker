FROM docker.io/alpine:latest
RUN apk add --no-cache tzdata su-exec bash supercronic tar gzip zip 7zip

RUN mkdir -p /opt/terraria-backup/worlds/ &&\
    chmod -R 775 /opt/terraria-backup/

COPY --chmod=755 scripts/entrypoint.sh /opt/terraria-backup/
COPY --chmod=755 scripts/backup.sh /opt/terraria-backup/
COPY --chmod=755 scripts/start.sh /opt/terraria-backup/

WORKDIR /opt/terraria-backup/

ENV TZ="Etc/UTC"
ENV PUID="1000"
ENV PGID="1000"

ARG VERSION
ENV VERSION=$VERSION

ENV CRONTIME="0 1 * * *"
ENV STARTTRIGGER="0"
ENV METHOD="cp"
ENV ROTATIONS="5"

ENTRYPOINT ["/opt/terraria-backup/entrypoint.sh"]

