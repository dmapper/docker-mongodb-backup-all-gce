#!/bin/bash

# Settings
DB_HOST="$MONGO_HOST"
DB_USER="$MONGO_USER"
DB_PASS="$MONGO_PASS"
BUCKET_NAME="$BUCKET"
FOLDER_NAME="$FOLDER"

# Path in which to create the backup (will get cleaned later)
BACKUP_PATH="/mnt/data/dump/"

CURRENT_DATE=$(date +"%Y%m%d-%H%M")

# Backup filename
BACKUP_FILENAME="$CURRENT_DATE.tar.gz"

# Create the backup
mongodump -h "$DB_HOST" -u "$DB_USER" -p "$DB_PASS" -o "$BACKUP_PATH"
cd $BACKUP_PATH || exit

# Archive and compress
tar -cvzf "$BACKUP_PATH""$BACKUP_FILENAME" ./*

# Copy to Google Cloud Storage
echo "Copying $BACKUP_PATH$BACKUP_FILENAME to gs://$BUCKET_NAME/$FOLDER_NAME/"
/root/gsutil/gsutil cp "$BACKUP_PATH""$BACKUP_FILENAME" gs://"$BUCKET_NAME"/"$FOLDER_NAME"/ 2>&1
echo "Copying finished"
echo "Removing backup data"
rm -rf $BACKUP_PATH*
