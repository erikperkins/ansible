#!/bin/bash
echo -e "host all all all md5\n" > "$PGDATA/pg_hba.conf"
