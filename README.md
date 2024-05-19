# [terraria-backup-docker](https://github.com/PassiveLemon/terraria-backup-docker) </br>

# WIP
Not currently functional.

Side-car Docker container to backup [terraria-docker](https://github.com/PassiveLemon/terraria-docker) or [tmodloader1.4-docker](https://github.com/PassiveLemon/tmodloader1.4-docker).

> [!WARNING]
> This is container alone is NOT a substitute for a proper backup solution. If losing data would cause you trouble, please, take proper care of it.

# Quick setup
1. Mount your Terraria world directory.
2. Run the container:
  - `docker run -d --name terraria-backup -v /opt/TerrariaServer/Worlds/:/opt/terraria-backup/worlds/ passivelemon/terraria-backup-docker:latest`

# 1. Setting up the container
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
