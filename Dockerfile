FROM debian:buster-slim
LABEL maintainer="github.com/daeks"

ARG USERNAME=steam
ARG USERID=1000
ARG GROUPID=1000

ARG STEAMCMDPKG=steamcmd_linux.tar.gz
ARG STEAMCMDURL=https://steamcdn-a.akamaihd.net/client/installer/$STEAMCMDPKG

ENV DEBIAN_FRONTEND noninteractive
ENV STEAMCMDDIR /home/steam/steamcmd

RUN set -x &&\
  apt-get update && apt-get upgrade -y &&\
  apt-get install -y --no-install-recommends --no-install-suggests \
    locale-gen wget ca-certificates lib32stdc++6 lib32gcc1
    
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
  
RUN set -x &&\  
  groupadd -g $GROUPID $USERNAME &&\
  useradd -m -g $GROUPID -u $USERID $USERNAME
  
RUN set -x &&\
  su $USERNAME -c \
    "mkdir -p ${STEAMCMDDIR} && cd ${STEAMCMDDIR} \
      && wget -qO- '${STEAMCMDURL}' | tar zxf -"
    
RUN set -x &&\
  apt-get remove --purge -y wget &&\
  apt-get clean autoclean &&\
  apt-get autoremove -y &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*^

USER $USERNAME

WORKDIR $STEAMCMDDIR

VOLUME $STEAMCMDDIR
