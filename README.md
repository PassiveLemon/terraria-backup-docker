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
This will loop over all worldnames in the world directory and back up each world file associated with that worldname, including Terraria world backup files (worldname.wld.bak).

## Environment variables
| Variable | Options | Default | Details |
|:-|:-|:-|:-|

| Method | Function |
|:-|:-|
`cp` | Copy to backup location. This is the default.
`tar` | Archive to backup location.
`zip` | Zip to backup location.
`7zip` | 7Zip to backup location.
