FROM alpine:3.6 as builder

ENV CONNECT_VERSION 1.0.1

RUN echo 'hosts: files dns' >> /etc/nsswitch.conf
RUN apk add --no-cache tzdata bash ca-certificates git tar build-base libressl-dev cmake wget linux-headers

RUN set -ex && \
  git clone https://github.com/eclipse/paho.mqtt.c.git && \
  mkdir build && cd build && \
  cmake -DPAHO_WITH_SSL=TRUE ../paho.mqtt.c && \
  make && make install

RUN set -ex && \
  wget -q http://libmodbus.org/releases/libmodbus-3.1.4.tar.gz && \
  tar xzf libmodbus-3.1.4.tar.gz && cd libmodbus-3.1.4 && \
  ./configure && make && make install

RUN set -ex && \
  wget -q http://archive.apache.org/dist/xml/xerces-c/Xerces-C_3_1_0/sources/xerces-c-3.1.0.tar.gz && \
  tar xzf xerces-c-3.1.0.tar.gz && cd xerces-c-3.1.0 && \
  ./configure && make && make install

COPY P773-VortexEdgeConnect-${CONNECT_VERSION}-Alpine-x86_64.tar.gz /vec.tar.gz
RUN set -ex && \
  mkdir -p /opt/Vortex && \
  tar -C /opt/Vortex -xzf /vec.tar.gz && \
  rm -rf /opt/Vortex/vcs_${CONNECT_VERSION}/examples/ && \
  rm -rf /opt/Vortex/vcs_${CONNECT_VERSION}/docs/ && \
  rm -f /opt/Vortex/vcs_${CONNECT_VERSION}/bin/connect_g && \
  rm -f /opt/Vortex/vcs_${CONNECT_VERSION}/*.pdf

FROM alpine:3.6

ENV CONNECT_VERSION 1.0.1

RUN echo 'hosts: files dns' >> /etc/nsswitch.conf
COPY --from=builder /usr/local/lib/libmodbus.* /usr/local/lib/
COPY --from=builder /usr/local/lib/libxerces-c*.so /usr/local/lib/
COPY --from=builder /usr/local/lib64/libpaho-mqtt3as.* /usr/local/lib64/
COPY --from=builder /opt/Vortex/ /opt/Vortex/
RUN set -ex && apk add --no-cache tzdata ca-certificates libressl libcurl libmicrohttpd libstdc++

EXPOSE 8080
VOLUME /data/xml

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
