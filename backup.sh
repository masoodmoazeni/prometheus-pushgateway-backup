#!/bin/bash

###################################  setting #################################
CURRENT_DATE_TIME=$(date +"%Y-%m-%d-%H-%M-%S")
CURRENT_DATE=$(date +"%Y-%m-%d")
SAVE_BACKUP_FOLDER=./home/backup-database-$CURRENT_DATE_TIME
IP_ADDRESS=192.168.1.1
TYPE_BACKUP=database
DESTINATION_ZIP_FILE=./backup

### database
MYSQL_USER="**********"
MYSQL_PASS="***********"
MYSQL_DATABASE="********"
###

### strategy backup

mysqldump -u$MYSQL_USER -p$MYSQL_PASS $MYSQL_DATABASE  > $CURRENT_DATE_TIME.sql     # for back up from mysql datbase -- phpmyadmin
mv $CURRENT_DATE_TIME.sql $SAVE_BACKUP_FOLDER
zip -r $CURRENT_DATE_TIME-$TYPE_BACKUP.zip $SAVE_BACKUP_FOLDER
###


###
if [ $? -eq 0 ]; then
    # Size of the zipped file in numbers
    ZIP_SIZE=$(du -sh $CURRENT_DATE_TIME-$TYPE_BACKUP.zip | cut -f1 | sed 's/[^0-9]*//g')
    echo "value $ZIP_SIZE"  | curl --data-binary @- http://$IP_ADDRESS:9091/metrics/job/database
else
    echo "value 0"  | curl --data-binary @- http://$IP_ADDRESS:9091/metrics/job/database
fi

mv $CURRENT_DATE_TIME-$TYPE_BACKUP.zip $DESTINATION_ZIP_FILE
rm -rf $SAVE_BACKUP_FOLDER