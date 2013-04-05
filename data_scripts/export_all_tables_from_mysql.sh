#!/bin/bash

#for f in *.csv; do ./export_one_table_from_mysql.sh $f; done

mysql -u root reportcard -B -e "show tables;" | perl -ne "next if /^Tables_in/; print;" | xargs -n 1 ./export_one_table_from_mysql.sh
