#!/bin/bash

DATA_DIRECTORY=$PGDATA/$POSTGRES_VERSION

if [ ! -d $DATA_DIRECTORY ]; then
    mkdir -p $DATA_DIRECTORY
    initdb -D $DATA_DIRECTORY
    echo "local all all trust" > $DATA_DIRECTORY/pg_hba.conf
    echo "host all nominatim 127.0.0.1/32 trust" >> $DATA_DIRECTORY/pg_hba.conf
    echo "host all nominatim ::1/128 trust" >> $DATA_DIRECTORY/pg_hba.conf
    echo "host nominatim www-data 127.0.0.1/32 trust" >> $DATA_DIRECTORY/pg_hba.conf
    echo "host nominatim www-data ::1/128 trust" >> $DATA_DIRECTORY/pg_hba.conf
    echo "shared_buffers = 2GB" >> $DATA_DIRECTORY/postgresql.conf
    echo "maintenance_work_mem = 10GB" >> $DATA_DIRECTORY/postgresql.conf
    echo "autovacuum_work_mem = 2GB" $DATA_DIRECTORY/postgresql.conf
    echo "work_mem = 50MB" >> $DATA_DIRECTORY/postgresql.conf
    echo "effective_cache_size = 24GB" >> $DATA_DIRECTORY/postgresql.conf
    echo "synchronous_commit = off" >> $DATA_DIRECTORY/postgresql.conf
    echo "max_wal_size = 2GB" >> $DATA_DIRECTORY/postgresql.conf
    echo "checkpoint_timeout = 60min" >> $DATA_DIRECTORY/postgresql.conf
    echo "checkpoint_completion_target = 0.9" >> $DATA_DIRECTORY/postgresql.conf
    echo "random_page_cost = 1.0" >> $DATA_DIRECTORY/postgresql.conf
    echo "wal_level = minimal" >> $DATA_DIRECTORY/postgresql.conf
    echo "max_wal_senders = 0" >> $DATA_DIRECTORY/postgresql.conf
    echo "autovacuum_max_workers = 1" >> $DATA_DIRECTORY/postgresql.conf
    echo "data_directory = '$DATA_DIRECTORY'" >> $DATA_DIRECTORY/postgresql.conf
    echo "external_pid_file = '$DATA_DIRECTORY/main.pid'" >> $DATA_DIRECTORY/postgresql.conf
    echo "fsync = off" > $DATA_DIRECTORY/postgresql.conf
    echo "full_page_writes = off" >> $DATA_DIRECTORY/postgresql.conf
fi
pg_ctl -w -m immediate -l $DATA_DIRECTORY/postgres.log -o "-c config_file=$DATA_DIRECTORY/postgresql.conf" start
psql -U postgres -d postgres -c "CREATE ROLE nominatim WITH LOGIN PASSWORD 'nominatim' SUPERUSER;"
psql -U postgres -d postgres -c "CREATE ROLE \"www-data\" NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS;"
tail -f $DATA_DIRECTORY/postgres.log