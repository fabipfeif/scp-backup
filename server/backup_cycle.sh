#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Define source and destination folders relative to the script's location
SOURCE_FOLDER="${SCRIPT_DIR}/Documents"
DESTINATION_FOLDER="${SCRIPT_DIR}/old_backups"

# Get the current date and time in YYYY-MM-DD_HH-MM-SS format
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Create the destination directory if it doesn't exist
mkdir -p "$DESTINATION_FOLDER"

# Copy the source folder and rename it with the current timestamp
cp -r "$SOURCE_FOLDER" "${DESTINATION_FOLDER}/Documents_${TIMESTAMP}"

# Print success message
echo "Folder '$SOURCE_FOLDER' copied to '$DESTINATION_FOLDER' and renamed to 'Documents_${TIMESTAMP}'"

# Check the number of backups in the destination folder
BACKUP_COUNT=$(ls -1 "$DESTINATION_FOLDER" | wc -l)

# If there are more than 7 backups, delete the oldest one
if [ "$BACKUP_COUNT" -gt 7 ]; then
    OLDEST_BACKUP=$(ls -1t "$DESTINATION_FOLDER" | tail -n 1)
    rm -r "${DESTINATION_FOLDER}/${OLDEST_BACKUP}"
    echo "Deleted oldest backup: $OLDEST_BACKUP"
fi