#!/bin/bash

DESTINATION_FOLDER=''
SOURCE_FOLDER=''
BACKUP_DIR=$DESTINATION_FOLDER
AWS_BUCKET=''

compressFiles() {

    DESTINATION=$1
    SOURCE=$2
    BACKUP_TIME=`date +%m_%d_%y_%H%M%S`

    tar -cpzf "$DESTINATION/backup_$BACKUP_TIME.tar.gz" $SOURCE

}

uploadFilesToS3() {

    BACKUP_DIR=$1
    AWS_BUCKET=$2

    aws s3 sync $BACKUP_DIR $AWS_BUCKET --exclude *.tmp
}

removeOlderBackups() {

    BACKUP_DIR=$1
    #the removal is only local, AWS does not delete files
    find $BACKUP_DIR -name "*.taz.gz" -type f -mtime +10 -exec rm -f {} \;
}

compressFiles $DESTINATION_FOLDER $SOURCE_FOLDER

uploadFilesToS3 $BACKUP_DIR $AWS_BUCKET

removeOlderBackups $BACKUP_DIR