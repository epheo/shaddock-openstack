FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm jre8-openjdk curl

RUN curl http://repo1.maven.org/maven2/org/onosproject/onos-releases/onos-1.12.0/onos-1.12.0.tar.gz \
    > onos.tar.gz

RUN tar -xzvf onos.tar.gz && mv onos-1.12.0 /opt/onos 
WORKDIR /opt/onos

# Configure ONOS to log to stdout
RUN sed -ibak '/log4j.rootLogger=/s/$/, stdout/' $(ls -d apache-karaf-*)/etc/org.ops4j.pax.logging.cfg

LABEL org.label-schema.name="ONOS" \
      org.label-schema.description="SDN Controller" \
      org.label-schema.usage="http://wiki.onosproject.org" \
      org.label-schema.url="http://onosproject.org" \
      org.label-scheme.vendor="Open Networking Foundation" \
      org.label-schema.schema-version="1.0"

# Ports
# 6653 - OpenFlow
# 6640 - OVSDB
# 8181 - GUI
# 8101 - ONOS CLI
# 9876 - ONOS intra-cluster communication
EXPOSE 6653 6640 8181 8101 9876

ENTRYPOINT ["./bin/onos-service"]
CMD ["server"]

