#!/bin/bash

: ${DB_NAME:="db"}

if [ -n "$1" ]; then
    password=$1
    echo "Setting new password for database ' $DB_NAME' and user '$username'."
    echo -e "user=monetdb\npassword=monetdb" > .monetdb
    mclient  $DB_NAME -s "ALTER USER SET PASSWORD '$password' USING OLD PASSWORD 'monetdb'";
    rm -f .monetdb
else
    echo "No password provided, aborting."
fi
