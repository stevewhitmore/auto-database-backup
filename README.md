# Auto Database Backup
A simple set of bash and scripts to export, compress, and download databases. Believe it or not, there are some shared hosting plans that don't include automatic database backups.

### How does it work?
This project is intended to run as a cron job locally and remotely. The local script (init_backup.sh) uploads the temporary remote script (backup.sh) that generates the backup. A permenant remote script (manage_backup.sh) runs shortly after the local script, compresses and renames the database backup, then deletes the temporary script along with the uncompressed backup.

Local crontab
```
5 0 * * 0 cd /path/to/executable; init_backup.sh # run script every Sunday at 12:05am
````

Remote crontab
```
7 0 * * 0 cd /path/to/executable; manage_backup.sh # run script every Sunday at 12:07am
````

### Requirements 
* bash
* sshpass

### This is a work in progress
This could be more efficient but is a better solution to what I was doing with Selenium in Python. Look for ways to
- Remove the need for a temporary script
- and/or find a way to trigger backups from a single origin (instead of 2 scripts on 2 different crontabs)