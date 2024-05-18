#!/usr/bin/env bash

function cpcmd () {
  wldname=$1
  cp /opt/terraria-backup/worlds/"$wldname.*" /opt/terraria-backup/worlds/Backup/
}

function tarcmd () {
  wldname=$1
  tar -czvf /opt/terraria-backup/worlds/Backup/"$wldname.tar.gz" /opt/terraria-backup/worlds/"$wldname.*"
}

function zipcmd () {
  wldname=$1
  zip /opt/terraria-backup/worlds/Backup/"$wldname.zip" /opt/terraria-backup/worlds/"$wldname.*"
}

function 7zipcmd () {
  wldname=$1
  7z a /opt/terraria-backup/worlds/Backup/"$wldname.7z" /opt/terraria-backup/worlds/"$wldname.*"
}

mkdir -p /opt/terraria-backup/worlds/Backup

# TEST THIS LOOP
for WORLD in /opt/terraria-backup/worlds/*.{wld,twld}; do
  if [ -z "$WORLD" ]; then
    echo "|| ERROR: No world files detected. ||"
    echo "|| Please ensure you have properly mounted your worlds directory. ||"
    exit 1
  fi
  WORLD="${WORLD%%.*}"
  EXTENSION="wld"
  if [ -e "$WORLD.twld" ]; then
    EXTENSION="twld"
  fi
  case $METHOD in
    "cp")
      echo "|| Method: cp. ||"
      cpcmd "$WORLD" "$EXTENSION"
    ;;
    "tar")
      echo "|| Method: tar. ||"
      tarcmd "$WORLD" "$EXTENSION"
    ;;
    "zip")
      echo "|| Method: zip. ||"
      zipcmd "$WORLD" "$EXTENSION"
    ;;
    "7zip")
      echo "|| Method: 7zip. ||"
      7zipcmd "$WORLD" "$EXTENSION"
    ;;
    "")
      echo "|| WARN: Method not provided. Defaulting to cp. ||"
      cpcmd "$WORLD" "$EXTENSION"
    ;;
    *)
      echo "|| ERROR: Invalid method $METHOD. ||"
      exit
    ;;
  esac
done

# We need to cron a script file with everything above. This is here for documentation purposes.
# (crontab -l 2>/dev/null; echo "${CRONTIME} (command)") | crontab -
