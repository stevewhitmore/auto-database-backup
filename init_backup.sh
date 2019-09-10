#!/bin/bash

# Send temporary script up, give the complementary script a chance to finish, pull down result

host_at_username=$(awk -F= '/host_at_username/ { print $2 }' config.txt)
remote_dir=$(awk -F= '/remote_dir/ { print $2 }' config.txt)
local_dir=$(awk -F= '/local_dir/ { print $2 }' config.txt)

sshpass -p 'some_superfly_password' scp backup.sh "$host_at_username":"$remote_dir"

source backup.sh

updated_filename=${db_name%.*}-$(date +%Y%m%d).sql

sleep 30s
sshpass -p 'some_superfly_password' scp "$host_at_username":"$remote_dir"/"${updated_filename}".tar.gz "$local_dir"
