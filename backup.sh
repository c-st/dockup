#!/bin/sh
set -e

# Get timestamp
: ${BACKUP_SUFFIX:=.$(date --utc +"%FT%T%Z")}
readonly tarball=$BACKUP_NAME$BACKUP_SUFFIX.tar.gz

# Create a gzip compressed tarball with the volume(s)
tar pczf $tarball $BACKUP_TAR_OPTION $PATHS_TO_BACKUP

# Create bucket, if it doesn't already exist
BUCKET_EXISTS=$(aws s3 ls | grep $S3_BUCKET_NAME | wc -l)
if [ "$BUCKET_EXISTS" -eq 0 ];
then
  aws s3 mb s3://$S3_BUCKET_NAME
fi

# Upload the backup to S3 with timestamp
aws s3 cp $tarball s3://$S3_BUCKET_NAME/$tarball

if [ $? -eq 0 ];
then
  echo "Backup of $tarball finished"
else
  echo "Backup of $tarball failed"
fi

rm $tarball
