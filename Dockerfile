FROM ghcr.io/jitesoft/debian:bullseye

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y --no-install-recommends \
    && apt-get -y --no-install-recommends install iptables apt-utils curl software-properties-common apt-transport-https ca-certificates wget tar dirmngr gnupg iproute2 make g++ locales git cmake zip unzip libtool-bin autoconf automake curl jq rpl locales
    
## User 
RUN addgroup --gid 998 container \
 && useradd -m -u 999 -d /home/container -g container -s /bin/bash container
  
    # Timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

  # Font 
RUN update-locale lang=en_US.UTF-8 \
 && dpkg-reconfigure --frontend noninteractive locales

   # Fixes
RUN apt-get install -y --no-install-recommends gcc g++ libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev libgcc1 lib32gcc-s1 gdb libc6 binutils xz-utils liblzo2-2 net-tools netcat telnet libatomic1 libsdl1.2debian libsdl2-2.0-0 libfontconfig libicu-dev icu-devtools libunwind8 libssl-dev libmariadb-dev-compat openssl libc6-dev libstdc++6 libssl1.1 lib32stdc++6 g++ make libirrlicht-dev cmake libpng-dev libjpeg-dev libxxf86vm-dev libgl1-mesa-dev libogg-dev libvorbis-dev libopenal-dev libcurl4-gnutls-dev libfreetype6-dev libgmp-dev libjsoncpp-dev dnsutils python3 build-essential zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl llvm libncurses5-dev libncursesw5-dev tk-dev libffi-dev liblzma-dev python3-openssl libespeak-dev libespeak1 libssl-dev less libasound2 libegl1-mesa libglib2.0-0 libnss3 libpci3 libpulse0 libxcursor1 libxslt1.1 libx11-xcb1 libxkbcommon0 python x11-xkb-utils libyaml-0-2 libpython2.7

  # Font 
RUN update-locale lang=en_US.UTF-8 \
 && dpkg-reconfigure --frontend noninteractive locales  

  # Others
RUN apt-get update && apt-get install -y --no-install-recommends libx11-dev libxkbfile-dev libsecret-1-dev toilet figlet toilet-fonts libncursesw5 re2c bison
RUN wget http://ftp.debian.org/debian/pool/main/l/leveldb/libleveldb1_1.17-1_amd64.deb \
 && wget http://ftp.de.debian.org/debian/pool/main/g/glibc/multiarch-support_2.28-10_amd64.deb \
 && wget http://ftp.debian.org/debian/pool/main/s/snappy/libsnappy1_1.1.2-3_amd64.deb \
 && dpkg --install libsnappy1_1.1.2-3_amd64.deb \
 && dpkg --install multiarch-support_2.28-10_amd64.deb \
 && dpkg --install libleveldb1_1.17-1_amd64.deb \
 && rm -rf libleveldb1_1.17-1_amd64.deb multiarch-support_2.28-10_amd64.deb libsnappy1_1.1.2-3_amd64.deb

   # xvbf
RUN apt-get update && apt-get install -y xvfb

  # Cleanup
RUN apt-get autoremove -y

  # hmmmmmm
RUN rm -rf /usr/bin/dd \
 && rm -rf /usr/bin/fallocate \
 && rm -rf /usr/bin/truncate \
 && rm -rf /usr/bin/xfs_mkfile 

  # loader
RUN apt-get update && apt-get install -y dos2unix
COPY ./minecraft.sh /minecraft.sh
RUN dos2unix /minecraft.sh && chmod +x /minecraft.sh
RUN apt-get update && apt-get install iputils-ping

# MariaDB
RUN apt-get update \
  && apt-get install -y libncurses5 libaio1

USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
