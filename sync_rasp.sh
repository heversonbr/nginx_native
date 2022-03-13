#!/bin/bash

source .env

echo "***************************************************************************"
echo "Rsync local repository and rasp $HOST"
echo "***************************************************************************"
echo "rsync -avh $SRC_PATH $USER@$HOST:$REMOTE_PATH --exclude-from='rsync_exclude_files.txt'"
echo "---------------------------------------------------------------------------"
rsync -avh $SRC_PATH $USER@$HOST:$REMOTE_PATH --exclude-from='sync_exclude_files.txt'
echo "---------------------------------------------------------------------------"
echo "Done !!!" 