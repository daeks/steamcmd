FROM ubuntu:latest
LABEL maintainer="github.com/daeks"

ARG USER_ID=1000
ARG GROUP_ID=1000

ENV DEBIAN_FRONTEND noninteractive
ENV STEAMCMDDIR /home/steam/steamcmd

RUN apt-get update &&\
  apt-get upgrade -y &&\
  apt-get install -y locales &&\
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN apt-get install -y curl lib32gcc1 libsdl2-dev libsdl2-2.0-0 &&\
  apt-get autoremove -y &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*^

RUN groupadd -g ${GROUP_ID} steam &&\
  useradd -m -g ${GROUP_ID} -u ${USER_ID} steam

USER steam
WORKDIR $STEAMCMDDIR
VOLUME $STEAMCMDDIR

RUN su steam -c "curl -sqL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar zxf - &&\
  rm -f steamcmd_linux.tar.gz"