FROM ghcr.io/jitesoft/debian:bullseye-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y --no-install-recommends install apt-utils curl software-properties-common apt-transport-https ca-certificates wget tar dirmngr gnupg iproute2 make g++ locales git cmake zip unzip libtool-bin autoconf automake jq rpl locales
    
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
RUN apt-get install -y --no-install-recommends gcc libcairo2-dev libpango1.0-dev libgcc1 gdb libc6 binutils xz-utils liblzo2-2 net-tools netcat telnet libatomic1 libsdl1.2debian libsdl2-2.0-0 libicu-dev icu-devtools libunwind8 libmariadb-dev-compat openssl libc6-dev libstdc++6 libssl1.1 libcurl4-gnutls-dev libjsoncpp-dev python3 build-essential zlib1g-dev libbz2-dev libreadline-dev libncurses5-dev libncursesw5-dev tk-dev libffi-dev libssl-dev less libasound2 libglib2.0-0 libnss3 libpulse0 libxslt1.1 libxkbcommon0 python libyaml-0-2 libpython2.7

  # Font 
RUN update-locale lang=en_US.UTF-8 \
 && dpkg-reconfigure --frontend noninteractive locales  

  # Others
RUN apt-get update && apt-get install -y --no-install-recommends libxkbfile-dev libsecret-1-dev toilet libncursesw5 re2c bison

  # Cleanup
RUN apt-get autoremove -y

  # hmmmmmm
RUN rm -rf /usr/bin/dd \
 && rm -rf /usr/bin/fallocate \
 && rm -rf /usr/bin/truncate \
 && rm -rf /usr/bin/xfs_mkfile 

  # loader
COPY ./minecraft.sh /minecraft.sh
RUN apt-get update \
 && apt-get install -y --no-install-recommends dos2unix iputils-ping \
 && dos2unix /minecraft.sh \
 && chmod +x /minecraft.sh

# MariaDB
RUN apt-get update \
  && apt-get install -y libncurses5 libaio1
 
# Minetest
RUN apt-get update \
  && apt-get install -y g++ make libc6-dev cmake libpng-dev libjpeg-dev libxxf86vm-dev libgl1-mesa-dev libsqlite3-dev libogg-dev libvorbis-dev libopenal-dev libcurl4-gnutls-dev libfreetype6-dev zlib1g-dev libgmp-dev libjsoncpp-dev libzstd-dev libluajit-5.1-dev libirrlicht1.8 libirrlicht-dev libirrlicht-doc

# Box64
COPY ./box64 /usr/bin/box64
RUN chmod +x /usr/bin/box64

USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
