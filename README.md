# Auto Database Backup
A simple pair of bash and selenium scripts to export, compress, and rename databases. Believe it or not, there are some shared hosting plans that don't include automatic database backups. But instead of paying up for a more expensive plan (which really would make more sense at this point) we'll run these scripts every week and get the backups ourselves.


### How does it work?
This project is intended to run as a cron job. The bash script kicks off a Python script, which uses Python's Selenium library to log into your shared hosting's phpMyAdmin page and download the latest copy of the specified database.

```
5 0 * * 0 cd /path/to/executable; run.sh # run script every Sunday at 12:05am
````

### Requirements 
* Python (works in v2.7 or v3+)
* pip
* selenium
* chromium-browser 
    * options.binary_location will need to be changed if non-Linux OS is running this script

### *\*\*\* This is a work in progress. The remaining tasks need to be completed before this project can be considered "finished":
- Fix headless problem; fails at download button press if run in headless mode
- Two functions are pretty much identical. Fix that wet junk.
- Finish rename of file
- Add compression