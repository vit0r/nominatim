#!/bin/bash

if [ ! -d $PGDATA ]; then
    mkdir -p $PGDATA/run
    initdb -D $PGDATA
    echo "local all all trust" > $PGDATA/pg_hba.conf
    echo "host all nominatim 127.0.0.1/32 trust" >> $PGDATA/pg_hba.conf
    echo "host all nominatim ::1/128 trust" >> $PGDATA/pg_hba.conf
    echo "host nominatim www-data 127.0.0.1/32 trust" >> $PGDATA/pg_hba.conf
    echo "host nominatim www-data ::1/128 trust" >> $PGDATA/pg_hba.conf
    echo "maintenance_work_mem = 10GB" >> $PGDATA/postgresql.conf
    echo "autovacuum_work_mem = 2GB" $PGDATA/postgresql.conf
    echo "work_mem = 50MB" >> $PGDATA/postgresql.conf
    echo "effective_cache_size = 24GB" >> $PGDATA/postgresql.conf
    echo "synchronous_commit = off" >> $PGDATA/postgresql.conf
    echo "checkpoint_timeout = 60min" >> $PGDATA/postgresql.conf
    echo "checkpoint_completion_target = 0.9" >> $PGDATA/postgresql.conf
    echo "random_page_cost = 1.0" >> $PGDATA/postgresql.conf
    echo "wal_level = minimal" >> $PGDATA/postgresql.conf
    echo "max_wal_senders = 0" >> $PGDATA/postgresql.conf
    echo "autovacuum_max_workers = 1" >> $PGDATA/postgresql.conf
    echo "data_directory = '$PGDATA'" >> $PGDATA/postgresql.conf
    echo "external_pid_file = '$PGDATA/main.pid'" >> $PGDATA/postgresql.conf
    echo "fsync = off" >> $PGDATA/postgresql.conf
    echo "full_page_writes = off" >> $PGDATA/postgresql.conf
    sed -i 's/shared_buffers = 128MB/shared_buffers = 2GB/' $PGDATA/postgresql.conf
    sed -i 's/max_wal_size = 1GB/max_wal_size = 4GB/' $PGDATA/postgresql.conf
fi
pg_ctl -w -m immediate -l $PGDATA/postgres.log -o "-k$PGDATA/run -c config_file=$PGDATA/postgresql.conf" start
psql -U postgres -d postgres -c "CREATE ROLE nominatim WITH LOGIN PASSWORD 'nominatim' SUPERUSER;"
psql -U postgres -d postgres -c "CREATE ROLE \"www-data\" NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS;"
echo "" > $PGDATA/postgres.log
tail -f $PGDATA/postgres.log