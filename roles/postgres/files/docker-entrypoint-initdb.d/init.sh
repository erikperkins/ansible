echo -e "host all all peer\nhost all all 127.0.0.1/32 md5" > "$PGDATA/pg_hba.conf"
