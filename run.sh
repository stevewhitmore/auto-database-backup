#!/bin/bash

date_time="$(date '+%A, %B %d %Y at %H:%M:%S')"
report_email=$(awk -F= '/EMAIL/ { print $2 }' config.txt)
log_file=$(awk -F= '/LOG_FILE/ { print $2 }' config.txt)

run_backup_db_script() {
    python ./backup_db.py
}
output=$(run_backup_db_script 2>&1)
echo -e $(date) '\n' $output >> $log_file

if [ $? -ne 0 ]; then
    mail -s "Database backup Script Failed" $report_email < /dev/null
    
    notify-send "Database backup Script Failed" "$date_time" \
    -i /usr/share/icons/gnome/48x48/status/weather-severe-alert.png \
    -u critical
else
    notify-send "Database backup successful" "$date_time" \
    -i /usr/share/icons/gnome/48x48/status/weather-clear.png \
    -u critical
fi

pkill chromium
exit $?
