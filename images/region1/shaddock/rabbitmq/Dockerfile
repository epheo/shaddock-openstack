FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm rabbitmq 

# Define environment variables.
ENV RABBITMQ_LOG_BASE /data/log
ENV RABBITMQ_MNESIA_BASE /data/mnesia

VOLUME ["/data/log", "/data/mnesia"]

WORKDIR /data

EXPOSE 5672
EXPOSE 15672
