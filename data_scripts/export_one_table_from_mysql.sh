#!/bin/bash
export DESTDIR='exports'
#export MY_FILENAME=$1
#export MY_BASENAME=`echo $MY_FILENAME | perl -pe 's/^.*?(\w+)\.csv\s*/$1/;'`
export MY_BASENAME=$1
#export MY_COLUMNS=`head -1 $MY_FILENAME`
export MY_COLUMNS=`mysql -u root reportcard -B -e "show columns from $MY_BASENAME" | perl -pe "s/^(\S*)\s.*$/\1/;" | perl -e "while(<>) { chomp; next if /^Field$/; print; print ',';}" | perl -pe "s/,$//;"`

#echo "columns: $MY_COLUMNS"

export MY_NEW_FILENAME="$DESTDIR/${MY_BASENAME}.csv"
export MY_TEMPFILE="/Users/jason/mysql/exports/tmp.csv"

echo "$MY_BASENAME"
#echo "...writing to $MY_NEW_FILENAME"

# create the destination directory
#mkdir -p exports


echo "...exporting data"
mysql -u root reportcard -B -e "select $MY_COLUMNS into outfile '$MY_TEMPFILE' fields terminated by ',' optionally enclosed by '\"' escaped by '\\\\' lines terminated by '\\n' from $MY_BASENAME where 1;"

echo "...adding column names and removing '\N' for nulls"
echo "$MY_COLUMNS" > $MY_NEW_FILENAME

cat $MY_TEMPFILE | perl -pe "s/,\\\\N/,/g;" >> $MY_NEW_FILENAME
rm $MY_TEMPFILE

echo "...done"
