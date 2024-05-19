FROM docker.io/alpine:latest

RUN apk add --no-cache bash grep tar gzip zip 7zip

RUN mkdir -p /opt/terraria-backup/worlds/

COPY entrypoint.sh /opt/terraria-backup/

RUN chmod -R 755 /opt/terraria-backup/ &&\
    chmod +x /opt/terraria-backup/entrypoint.sh

WORKDIR /opt/terraria-backup/

ENV CRONTIME="0 1 * * *"
ENV METHOD="cp"
ENV ROTATIONS="5"

ENTRYPOINT ["/opt/terraria-backup/entrypoint.sh"]
