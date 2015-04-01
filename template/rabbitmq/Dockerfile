FROM panama/base:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

# Based on https://github.com/dockerfile/rabbitmq

# Add files.
ADD rabbitmq-start /usr/local/bin/

# Install RabbitMQ.
RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y rabbitmq-server && \
    rabbitmq-plugins enable rabbitmq_management && \
    chmod +x /usr/local/bin/rabbitmq-start

# Define environment variables.
ENV RABBITMQ_LOG_BASE /data/log
ENV RABBITMQ_MNESIA_BASE /data/mnesia

# Define mount points.
VOLUME ["/data/log", "/data/mnesia"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["rabbitmq-start"]

# Expose ports.
EXPOSE 5672
EXPOSE 15672
