#!/usr/bin/env bash

function rotator () {
  WLD=$1 # World file
  CNT=$2 # Rotation count
  EXT=$3 # Backup file extension
  # Delete all backups greater than or equal to the rotation count
  for BACKUP in /opt/terraria-backup/worlds/Backup/"${WLD}".*"${EXT}"; do
    # Isolate the backup number
    BACKUPNUM=$(basename "$BACKUP")
    BACKUPNUM="${BACKUPNUM#"$WLD".}"
    BACKUPNUM="${BACKUPNUM%%.*}"
    if ((BACKUPNUM >= CNT)); then
      rm "/opt/terraria-backup/worlds/Backup/$WLD.${BACKUPNUM}${EXT}"
    fi
  done
  # Increment all backups by 1 if it exists
  for ((INC=CNT; INC >= 0; INC--)); do
    if [ -e "/opt/terraria-backup/worlds/Backup/$WLD.${INC}${EXT}" ]; then
      mv "/opt/terraria-backup/worlds/Backup/$WLD.${INC}${EXT}" "/opt/terraria-backup/worlds/Backup/$WLD.$((INC+1))${EXT}"
    fi
  done
}

# $1 = World file
function cpcmd () {
  cp "/opt/terraria-backup/worlds/$1" "/opt/terraria-backup/worlds/Backup/$1.0"
}

function tarcmd () {
  tar -czvf "/opt/terraria-backup/worlds/Backup/$1.0.tar.gz" "/opt/terraria-backup/worlds/$1"
}

function zipcmd () {
  zip "/opt/terraria-backup/worlds/Backup/$1.0.zip" "/opt/terraria-backup/worlds/$1"
}

function 7zipcmd () {
  7z a "/opt/terraria-backup/worlds/Backup/$1.0.7z" "/opt/terraria-backup/worlds/$1"
}

mkdir -p /opt/terraria-backup/worlds/Backup

for FILE in /opt/terraria-backup/worlds/*.{wld,twld}; do
  if [ -f "$FILE" ]; then
    if [ -z "$FILE" ]; then
      echo "|| ERROR: No world files detected. ||"
      echo "|| Please ensure you have properly mounted your worlds directory. ||"
      exit 1
    fi
    WORLD=$(basename "$FILE")
    # Check if the world is a twld file
    if [ "$WORLD" = "${WORLD%%.*}.twld" ]; then
      WORLD="${WORLD%%.*}.twld"
    fi
    case $METHOD in
      "cp")
        echo "|| File: $WORLD | Method: cp ||"
        cpcmd "$WORLD"
        rotator "$WORLD" "$ROTATIONS" ""
      ;;
      "tar")
        echo "|| File: $WORLD | Method: tar ||"
        tarcmd "$WORLD"
        rotator "$WORLD" "$ROTATIONS" ".tar.gz"
      ;;
      "zip")
        echo "|| File: $WORLD | Method: zip ||"
        zipcmd "$WORLD"
        rotator "$WORLD" "$ROTATIONS" ".zip"
      ;;
      "7zip")
        echo "|| File: $WORLD | Method: 7zip ||"
        7zipcmd "$WORLD"
        rotator "$WORLD" "$ROTATIONS" ".7z"
      ;;
      "")
        echo "|| WARN: Method not provided. Defaulting to cp. File: $WORLD ||"
        cpcmd "$WORLD"
        rotator "$WORLD" "$ROTATIONS" ""
      ;;
      *)
        echo "|| ERROR: Invalid method $METHOD. ||"
        exit
      ;;
    esac
    echo "|| $WORLD backed up. ||"
  fi
done

# We need to cron a script file with everything above. This is here for documentation purposes.
# (crontab -l 2>/dev/null; echo "${CRONTIME} (command)") | crontab -
