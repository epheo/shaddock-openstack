FROM shaddock/seed:latest
MAINTAINER Thibaut Lapierre <root@epheo.eu>

ADD rabbitmq-start /usr/local/bin/
RUN chmod +x /usr/local/bin/rabbitmq-start

RUN pacman -Sy --noconfirm rabbitmq 

# Define environment variables.
ENV RABBITMQ_LOG_BASE /data/log
ENV RABBITMQ_MNESIA_BASE /data/mnesia

# Define mount points.
VOLUME ["/data/log", "/data/mnesia"]

WORKDIR /data

EXPOSE 5672
EXPOSE 15672

CMD ["rabbitmq-start"]
