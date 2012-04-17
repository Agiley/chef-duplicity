#!/bin/sh

. /etc/duplicity/config.sh

for BACKUP_CONF in /etc/duplicity/backups/*.sh
do
  . $BACKUP_CONF
  nice ionice -c3 duplicity \
    --name "$BACKUP_NAME" \
    --archive-dir "$ARCHIVE" \
    --gpg-options "--homedir=~$DUPLICITY_USER/.gnupg" \
    --full-if-older-than "$FULL_IF_OLDER_THAN" \
    --volsize "$VOLUME_SIZE" \
    --s3-use-new-style \
    "$BACKUP_PATH" \
    "s3+http://$S3_BUCKET/$BACKUP_NAME" \
    | logger -t duplicity
done