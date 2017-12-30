FROM alpine
MAINTAINER Denbeigh Stevens <denbeigh@denbeighstevens.com>

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.license="MIT" \
      org.label-schema.name="denbeigh2000/docker-autossh" \
      org.label-schema.url="https://hub.docker.com/r/denbeigh2000/docker-autossh/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-type="Git" \
      org.label-schema.vcs-url="https://github.com/denbeigh2000/docker-autossh"

ENTRYPOINT ["/entrypoint.sh"]
ADD /entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENV \
    TERM=xterm                  \
    AUTOSSH_GATETIME=30         \
    AUTOSSH_POLL=10             \
    AUTOSSH_FIRST_POLL=30       \
    AUTOSSH_LOGLEVEL=0          \
    AUTOSSH_PORT=-1             \
    SSH_TARGET_PORT=22          \
    EXTENDED_SSH_OPTS=""

# nobody wants to be that guy who hits the same server every time
RUN echo "@community http://dl-1.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories
RUN echo "@community http://dl-2.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories
RUN echo "@community http://dl-3.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories
RUN echo "@community http://dl-4.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories
RUN echo "@community http://dl-5.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories
RUN echo "@community http://dl-6.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories
RUN echo "@community http://dl-7.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories
RUN echo "@community http://dl-8.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories
RUN apk add --update autossh@community
RUN rm -rf /var/lib/apt/lists/*
