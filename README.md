# Dockup

Docker image to backup Docker container volumes to Amazon S3 in regular intervals (cron based). Also includes the possibility to restore from a backup.

In order to use a minimal amount of space it is based on [Alpine Linux](http://www.alpinelinux.org).

Inspired by [tutumcloud/dockup](https://github.com/tutumcloud/dockup) and
[outcoldman/docker-backup](https://github.com/outcoldman/docker-backup).

## Usage

You have a container running with one or more volumes:

```
docker run -d --name myservice myservice
```

From executing `docker inspect myservice` we see that this container has two volumes:

```
"Volumes": {
  "/etc/myservice": {},
  "/var/lib/myservice": {}
}
```

Launch `dockup` container with the following flags:

```
docker run \
	--volumes-from myservice \
	--name myservice-backup
	-e AWS_ACCESS_KEY_ID=<your_key_here> \
	-e AWS_SECRET_ACCESS_KEY=<your_secret_here> \
	-e AWS_DEFAULT_REGION=eu-central-1 \
	-e BACKUP_NAME=myservice \
	-e PATHS_TO_BACKUP=/etc/myservice /var/lib/myservice \
	-e S3_BUCKET_NAME=docker-backups \
	-e BACKUP_CRON_SCHEDULE=30 2 * * * \
    chrisst/dockup
```

`dockup` will use your AWS credentials to create a new bucket with the same
name as defined in the environment variable `S3_BUCKET_NAME`. 
Every night at 2:30 the content of `PATHS_TO_BACKUP` will be tarballed, gzipped and uploaded to the S3 bucket.

The backup archive created in above example would be:
`s3://docker-backups/myservice.2015-10-25T02:30:00Z.tar.gz`

## Restore

To perform a restore launch the container with the `RESTORE` variable set to true:

```
docker run \
	--volumes-from myservice \
	--name myservice-backup
	-e AWS_ACCESS_KEY_ID=<your_key_here> \
	-e AWS_SECRET_ACCESS_KEY=<your_secret_here> \
	-e AWS_DEFAULT_REGION=eu-central-1 \
	-e BACKUP_NAME=myservice \
	-e S3_BUCKET_NAME=docker-backups \
	-e RESTORE=true \
    chrisst/dockup
```