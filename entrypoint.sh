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
  for ((INC=COUNT; INC >= 1; INC--)); do
    if [ -e "/opt/terraria-backup/worlds/Backup/$WLDNAME.${INC}${BCKEXT}" ]; then
      mv "/opt/terraria-backup/worlds/Backup/$WLDNAME.${INC}${BCKEXT}" "/opt/terraria-backup/worlds/Backup/$WLDNAME.$((INC+1))${BCKEXT}"
    fi
  done
}

# $1 = Worldname
# $2 = Extension
function cpcmd () {
  cp "/opt/terraria-backup/worlds/$1.$2" "/opt/terraria-backup/worlds/Backup/$1.1"
}

function tarcmd () {
  tar -czvf "/opt/terraria-backup/worlds/Backup/$1.1.tar.gz" "/opt/terraria-backup/worlds/$1.$2"
}

function zipcmd () {
  zip "/opt/terraria-backup/worlds/Backup/$1.1.zip" "/opt/terraria-backup/worlds/$1.$2"
}

function 7zipcmd () {
  7z a "/opt/terraria-backup/worlds/Backup/$1.1.7z" "/opt/terraria-backup/worlds/$1.$2"
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
    WLDEXT="wld"
    if [ -e "$WORLD.twld" ]; then
      echo "twld"
      WLDEXT="twld"
    fi
    WORLD="${WORLD%%.*}"
    case $METHOD in
      "cp")
        echo "|| File: $WORLD.$WLDEXT | Method: cp ||"
        rotator "$WORLD" "$ROTATIONS" ""
        cpcmd "$WORLD" "$WLDEXT"
      ;;
      "tar")
        echo "|| File: $WORLD.$WLDEXT | Method: tar ||"
        rotator "$WORLD" "$ROTATIONS" ".tar.gz"
        tarcmd "$WORLD" "$WLDEXT"
      ;;
      "zip")
        echo "|| File: $WORLD.$WLDEXT | Method: zip ||"
        rotator "$WORLD" "$ROTATIONS" ".zip"
        zipcmd "$WORLD" "$WLDEXT"
      ;;
      "7zip")
        echo "|| File: $WORLD.$WLDEXT | Method: 7zip ||"
        rotator "$WORLD" "$ROTATIONS" ".7z"
        7zipcmd "$WORLD" "$WLDEXT"
      ;;
      "")
        echo "|| WARN: Method not provided. Defaulting to cp. File: $WORLD.$WLDEXT ||"
        rotator "$WORLD" "$ROTATIONS" ""
        cpcmd "$WORLD" "$WLDEXT"
      ;;
      *)
        echo "|| ERROR: Invalid method $METHOD. ||"
        exit
      ;;
    esac
    echo "|| $WORLD.$WLDEXT backed up. ||"
  fi
done

# We need to cron a script file with everything above. This is here for documentation purposes.
# (crontab -l 2>/dev/null; echo "${CRONTIME} (command)") | crontab -
