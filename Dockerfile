FROM ubuntu:latest
LABEL maintainer="github.com/daeks"

ARG USERNAME=steam
ARG USERID=1000
ARG GROUPID=1000
ARG STEAMCMDPKG=steamcmd_linux.tar.gz
ARG STEAMCMDURL=https://steamcdn-a.akamaihd.net/client/installer/${STEAMCMDPKG}

ENV DEBIAN_FRONTEND noninteractive
ENV STEAMCMDDIR /home/steam/steamcmd
ENV MODE COMPOSE

RUN apt-get update &&\
  apt-get upgrade -y &&\
  apt-get install -y locales &&\
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN apt-get install -y curl lib32stdc++6 lib32gcc1 libsdl2-dev libsdl2-2.0-0 &&\
  apt-get autoremove -y &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*^

RUN groupadd -g ${GROUPID} ${USERNAME} &&\
  useradd -m -g ${GROUPID} -u ${USERID} ${USERNAME}

RUN set -x &&\
  su - ${USERNAME} -c "mkdir -p ${STEAMCMDDIR} && cd ${STEAMCMDDIR} &&\
  curl -sqL ${STEAMCMDURL} | tar zxf - &&\
  rm -f ${STEAMCMDPKG}"

USER steam
WORKDIR $STEAMCMDDIR
VOLUME $STEAMCMDDIR
