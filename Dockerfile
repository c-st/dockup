FROM alpine:latest
MAINTAINER Christian Stangier <christian@stangier.email>

RUN apk add --update-cache python py-pip ca-certificates tzdata &&\
    pip install awscli &&\
    rm -fR /etc/periodic &&\
    rm -rf /var/cache/apk/*

COPY backup.sh /etc/scripts/backup.sh
COPY restore.sh /etc/scripts/restore.sh
RUN chmod 755 /etc/scripts/*.sh

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

ENV AWS_ACCESS_KEY_ID FILL_OUT-ACCESS-KEY-ID
ENV AWS_SECRET_ACCESS_KEY FILL-OUT-ACCESS-KEY
ENV AWS_DEFAULT_REGION eu-central-1
ENV S3_BUCKET_NAME docker-backups
ENV BACKUP_NAME myservice
ENV PATHS_TO_BACKUP /some/path
ENV BACKUP_CRON_SCHEDULE 0 2 * * *
ENV RESTORE false

CMD /sbin/entrypoint.sh
