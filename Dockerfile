ARG FIVEM_NUM=5181
ARG FIVEM_VER=5181-9eba8dcc91ee4c6ab009fcf7a47837edf81efd1a
ARG DATA_VER=44fc68d7ee1b94ad67a211a6ff8234ce4ff760c8

FROM spritsail/alpine:3.14 as builder

ARG FIVEM_VER
ARG DATA_VER

WORKDIR /output
RUN wget -O- http://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${FIVEM_VER}/fx.tar.xz \
        | tar xJ --strip-components=1 \
            --exclude alpine/dev --exclude alpine/proc \
            --exclude alpine/run --exclude alpine/sys \
 && mkdir -p /output/opt/cfx-server-data /output/usr/local/share \
 && apk -p $PWD add tini 

RUN apk add open rc && apk add --no-cache openssh \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && adduser -h /config -s /bin/sh -D user \
    && echo -n 'user:Erryial123' | chpasswd && ssh-keygen -A \
    && rc-update add sshd




ADD server.cfg opt/cfx-server-data
ADD entrypoint usr/bin/entrypoint
ADD resources opt/cfx-server-data/resources

RUN chmod +x /output/usr/bin/entrypoint

#================

FROM scratch

ARG FIVEM_VER
ARG FIVEM_NUM
ARG DATA_VER

LABEL maintainer="Spritsail <fivem@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="FiveM" \
      org.label-schema.url="https://fivem.net" \
      org.label-schema.description="FiveM is a modification for Grand Theft Auto V enabling you to play multiplayer on customized dedicated servers." \
      org.label-schema.version=${FIVEM_NUM} \
      io.spritsail.version.fivem=${FIVEM_VER} \
      io.spritsail.version.fivem_data=${DATA_VER}

COPY --from=builder /output/ /

WORKDIR /config
EXPOSE 30120

# Default to an empty CMD, so we can use it to add seperate args to the binary
CMD [""]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/entrypoint"]
