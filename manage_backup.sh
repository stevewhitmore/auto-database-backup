#!/bin/bash

# Run backup script if present
backup_script_exists=$(find . -type f -iname backup.sh)
[ -z "$backup_script_exists" ] && exit
./backup.sh

# Get "db_name" from temporary script
source backup.sh

# If the backup was made add date to filename and compress
file="$db_name".sql
found=$(find . -type f -iname "$file")
[ -z "$found" ] && exit

updated_filename=${file%.*}-$(date +%Y%m%d).sql
mv "$file" "$updated_filename"
tar -czf ./"${updated_filename}".tar.gz "$updated_filename"

# Erase uncompressed file and temporary script
rm "$updated_filename" ./backup.sh