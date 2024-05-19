#!/usr/bin/env bash


function rotator () {
  WLDNAME=$1
  COUNT=$2
  BCKEXT=$3
  # Delete all backups greater than or equal to the rotation count
  for BACKUP in /opt/terraria-backup/worlds/Backup/"${WLDNAME}".*"${BCKEXT}"; do
    # Isolate the backup number
    BACKUP=$(basename "$BACKUP")
    BACKUP="${BACKUP#"$WLDNAME".}"
    BACKUP="${BACKUP%%.*}"
    if ((BACKUP >= COUNT)); then
      rm "/opt/terraria-backup/worlds/Backup/$WLDNAME.${BACKUP}${BCKEXT}"
    fi
  done
  # Increment all backups by 1 if it exists
  for ((INC=COUNT; INC >= 0; INC--)); do
    if [ -e "/opt/terraria-backup/worlds/Backup/$WLDNAME.${INC}${BCKEXT}" ]; then
      mv "/opt/terraria-backup/worlds/Backup/$WLDNAME.${INC}${BCKEXT}" "/opt/terraria-backup/worlds/Backup/$WLDNAME.$((INC+1))${BCKEXT}"
    fi
  done
}

# $1 = Worldname
# $2 = Extension
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

for WORLD in /opt/terraria-backup/worlds/*.{wld,twld}; do
  if [ -f "$WORLD" ]; then
    if [ -z "$WORLD" ]; then
      echo "|| ERROR: No world files detected. ||"
      echo "|| Please ensure you have properly mounted your worlds directory. ||"
      exit 1
    fi
    WORLD=$(basename "$WORLD")
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
