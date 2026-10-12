FROM alpine:3.21

RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    docker-cli \
    docker-cli-compose \
    openssh-client \
    restic \
    tzdata \
    && update-ca-certificates

# supercronic: cron-compatible scheduler for containers
ARG SUPERCRONIC_VERSION=0.2.33
ARG TARGETARCH=amd64
RUN curl -fsSL -o /usr/local/bin/supercronic \
      "https://github.com/aptible/supercronic/releases/download/v${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH}" \
    && chmod +x /usr/local/bin/supercronic

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV RESTIC_REPOSITORY=/repo
ENV BACKUP_CRON="0 3 * * *"

ENTRYPOINT ["/entrypoint.sh"]
