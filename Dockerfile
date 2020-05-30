FROM debian:buster-slim
LABEL maintainer="github.com/daeks"

ENV USERNAME=steam
ARG USERID=1000

ARG STEAMCMDPKG=steamcmd_linux.tar.gz
ARG STEAMCMDURL=https://steamcdn-a.akamaihd.net/client/installer/$STEAMCMDPKG

ENV STEAMHOMEDIR /home/$USERNAME
ENV STEAMCMDDIR $STEAMHOMEDIR/steamcmd

ENV DEBIAN_FRONTEND noninteractive

RUN set -x &&\
  apt-get update && apt-get upgrade -y &&\
  apt-get install -y --no-install-recommends --no-install-suggests \
    procps locales htop nano wget rsync ca-certificates lib32stdc++6 lib32gcc1 libsdl1.2debian
    
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
  
RUN set -x &&\
  useradd -m -u $USERID $USERNAME &&\
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
