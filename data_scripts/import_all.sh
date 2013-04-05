#!/bin/bash
for f in *.csv; do mysqlimport -u root --ignore-lines=1 --fields-optionally-enclosed-by='"' --fields-terminated-by=',' reportcard ~jason/Dropbox/NC\ Education\ Data/CSV\ Exports/csv_data_export/$f; done
