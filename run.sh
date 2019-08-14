#!/bin/bash

date_time="$(date '+%A, %B %d %Y at %H:%M:%S')"
report_email=$(awk -F= '/EMAIL/ { print $2 }' config.txt)
log_file=$(awk -F= '/LOG_FILE/ { print $2 }' config.txt)

run_backup_db_script() {
    python ./backup_db.py
}
output=$(run_backup_db_script 2>&1)
echo -e "$(date)" '\n' "$output" >> "$log_file"

if [ -z "$output" ]; then
    # No output is good output
    notification_message="Database backup successful"
    notification_image="/usr/share/icons/gnome/48x48/status/weather-clear.png"
else
    notification_message="Database backup script failed"
    notification_image="/usr/share/icons/gnome/48x48/status/weather-severe-alert.png"

    mail -s "$notification_message" "$report_email" < /dev/null
fi

notify-send "$notification_message" "$date_time" \
-i "$notification_image" \
-u critical

pkill chromium
exit $?
