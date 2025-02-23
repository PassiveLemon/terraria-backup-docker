# [terraria-backup-docker](https://github.com/PassiveLemon/terraria-backup-docker) </br>

Side-car Docker container to backup [terraria-docker](https://github.com/PassiveLemon/terraria-docker).

> [!WARNING]
> This is container alone is NOT a substitute for a proper backup solution. If losing data would cause you trouble, please, take proper care of it.

# Quick setup
1. Mount your Terraria world directory.
2. Run the container: <b>(Make sure to modify any values that you need.)</b>
  - `docker run -d --name terraria-backup -v /opt/TerrariaServer/Worlds/:/opt/terraria-backup/worlds/ passivelemon/terraria-backup-docker:latest`

# Setting up the container
This will loop over all worldnames in the world directory and back up the world files associated with that name. The backups are placed in a Backups subdirectory in the same directory as the world files.

## Environment variables
| Variable | Options | Default | Details |
|:-|:-|:-|:-|
`CRONTIME` | `crontime (* * * * *)` | `0 1 * * * (Every day at 1 AM)` | The cron time that the container follows for the backup schedule.
`STARTTRIGGER` | `boolean` | `0` | Whether to run the backup upon container start.
`METHOD` | `cp` `tar` `zip` `7zip` | `cp` | The method of storage to use when backing up. More details below.
`ROTATIONS` | `integer` | `5` | How many backups to rotate through.

| Method | Function |
|:-|:-|
`cp` | Copy to backup location. This is the default.
`tar` | Archive (with gzip) to backup location.
`zip` | Zip to backup location.
`7zip` | 7Zip to backup location.

### Docker run </br>
```
docker run -d --name <container name> -v <world dir>:/opt/terraria-backup/config/ passivelemon/terraria-backup-docker:latest
```

### Docker Compose
```yml
version: '3.3'
services:
  terraria-backup-docker:
    image: passivelemon/terraria-backup-docker:latest
    container_name: terraria-backup-docker
    volumes:
      - <world dir>:/opt/terraria-backup/worlds/
```

## Examples </br>
### Docker run
```
docker run -d --name terraria-backup-docker -v /opt/terrariaServer/Worlds/:/opt/terraria-backup/config/ -e METHOD="tar" -e STARTTRIGGER="1" passivelemon/terraria-backup-docker:latest
```

### Docker compose
```yml
version: '3.3'
services:
  terraria-backup-docker:
    image: passivelemon/terraria-backup-docker:latest
    container_name: terraria-backup-docker
    volumes:
      - /opt/terrariaServer/Worlds/:/opt/terraria-backup/worlds/
    environment:
      METHOD: 'tar'
      STARTTRIGGER: '1'
```

