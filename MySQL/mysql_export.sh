#!/bin/sh

export PATH=/bin:/usr/bin

DBS=0 # Total databasses
TBS=0 # Total tables

# Current date, for backup folder
CDATE=`date +%Y-%m-%d`
WKDIR="/backup/${CDATE}"

mkdir -p $WKDIR

for DB in $(mysql --defaults-file=/root/.my.cnf -sNe "SHOW DATABASES;")
do
    # Exclude metadata
    if [[ ${DB} != 'information_schema' ]]
    then
        # Create a folder for each database
        echo -e "Database: ${DB}..."
        DBDIR="${WKDIR}/${DB}"
        mkdir -p ${DBDIR}
        DBS=$((${DBS}+1))
        # Loop through the tables
        for TBL in `mysql --defaults-file=/root/.my.cnf ${DB} -sNe "SHOW TABLES;"`
        do
            # Export the tables and compress the result
            echo -n "  Exporting table ${DB}.${TBL}..."
            mysqldump --defaults-file=/root/.my.cnf --opt ${DB} ${TBL} | bzip2 -9 > "${DBDIR}/${TBL}.sql.gz"
            if [ $? -eq 0 ]; then echo "Done."; TBS=$((${TBS}+1)); else echo "Failed."; fi;
        done
    fi
done

# Print the results
echo
printf "********************************************\n"
printf "**** %-34s ****\n"                              "Exported databases: ${DBS}"
printf "**** %-34s ****\n"                              "Exported tables: ${TBS}"
printf "********************************************\n"
