#!/bin/bash

db_name=<db_name>

mysqldump --no-tablespaces --host=<sql_host_name> --user=<db_user> --password='whatever_the_password_is' "$db_name" > "$db_name".sql
