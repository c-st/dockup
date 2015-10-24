FROM alpine:latest
MAINTAINER Christian Stangier <christian@stangier.email>

RUN apk add --update-cache python py-pip ca-certificates tzdata &&\
    pip install awscli &&\
    rm -fR /etc/periodic &&\
    rm -rf /var/cache/apk/*

ADD backup.sh /backup.sh
ADD restore.sh /restore.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

ENV AWS_ACCESS_KEY_ID FILL_OUT-ACCESS-KEY-ID
ENV AWS_SECRET_ACCESS_KEY FILL-OUT-ACCESS-KEY
ENV AWS_DEFAULT_REGION eu-central-1
ENV S3_BUCKET_NAME my-bucket-name
ENV PATHS_TO_BACKUP /some/path
ENV BACKUP_CRON_SCHEDULE 0 2 * * *
ENV BACKUP_NAME backup
ENV RESTORE false

CMD /sbin/entrypoint.sh
