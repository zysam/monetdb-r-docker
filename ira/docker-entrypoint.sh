#!/bin/bash

: ${DB_NAME:="db"}

chown -R monetdb:monetdb /var/monetdb5

if [ ! -d "/var/monetdb5/dbfarm" ]; then
   monetdbd create /var/monetdb5/dbfarm
   echo "listenaddr=0.0.0.0" >> /var/monetdb5/dbfarm/.merovingian_properties
else
    echo "Existing dbfarm found in '/var/monetdb5/dbfarm'"
fi

monetdbd start /var/monetdb5/dbfarm

sleep 5
if [ ! -d "/var/monetdb5/dbfarm/$DB_NAME" ]; then
    monetdb create $DB_NAME && \
    monetdb set embedr=true $DB_NAME && \
    monetdb set embedpy=true $DB_NAME && \
    monetdb release $DB_NAME
else
    echo "Existing database found in '/var/monetdb5/dbfarm/db'"
fi

for i in {30..0}; do
    echo 'Testing MonetDB connection ' $i
    mclient -d $DB_NAME -s 'SELECT 1' &> /dev/null
    if [ $? -ne 0 ] ; then
      echo 'Waiting for MonetDB to start...'
      sleep 1
    else
        echo 'MonetDB is running'
        break
    fi
done
if [ $i -eq 0 ]; then
    echo >&2 'MonetDB startup failed'
    exit 1
fi

mkdir -p /var/log/monetdb
chown -R monetdb:monetdb /var/log/monetdb

echo "Initialization done"
echo "supervisord start"

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf