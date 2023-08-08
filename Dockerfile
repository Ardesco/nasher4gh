FROM debian:bookworm-slim

ARG NWNSERVER_VERSION="8193.35-40"
ARG NWNSC_VERSION="1.1.5"
ARG NIM_VERSION="1.6.14"
ARG NASHER_VERSION="0.20.2"

LABEL maintainer="Mark Collin (@Ardesco)"

## Install required libs/utilities
RUN apt update &&  \
    apt-get upgrade -y
RUN apt-get install gcc libc6 libncurses5 libstdc++6 g++ libpcre3 libsqlite3-0 sqlite3 openssl wget tar xz-utils unzip git -y
RUN rm -rf /var/lib/apt/lists/* /root/.cache/* /usr/share/doc/* /var/cache/man/*
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib

# Install nwserver (for compilation)
ARG NWSERVER_DATA_PATH=/nwn
ARG NWNSERVER_ZIP_FILENAME="nwnee-dedicated-${NWNSERVER_VERSION}.zip"
ARG NWNSERVER_LOCATION="https://nwn.beamdog.net/downloads/${NWNSERVER_ZIP_FILENAME}"
RUN wget ${NWNSERVER_LOCATION} &&  \
    unzip ${NWNSERVER_ZIP_FILENAME} -d ${NWSERVER_DATA_PATH} &&  \
    rm ${NWNSERVER_ZIP_FILENAME}

# Install nwnsc compiler
ARG NWNSC_FILENAME="nwnsc-linux-v${NWNSC_VERSION}.zip"
ARG NWNSC_LOCATION="https://github.com/nwneetools/nwnsc/releases/download/v${NWNSC_VERSION}/${NWNSC_FILENAME}"
RUN wget ${NWNSC_LOCATION} &&  \
    unzip ${NWNSC_FILENAME} -d /usr/local/bin/ &&  \
    chmod +x /usr/local/bin/nwnsc &&  \
    rm ${NWNSC_FILENAME}

# Install nim
ARG NIM_FILENAME="nim-${NIM_VERSION}-linux_x64.tar.xz"
ARG NIM_LOCATION="https://nim-lang.org/download/${NIM_FILENAME}"
RUN wget ${NIM_LOCATION}  \
    && tar -xf ${NIM_FILENAME} -C /lib  \
    && rm ${NIM_FILENAME}
ENV PATH="/lib/nim-${NIM_VERSION}/bin:$PATH"

# Install nasher
RUN nimble install nasher@#${NASHER_VERSION} -y &&  \
    chmod +x /root/.nimble/bin/nasher
ENV PATH="/root/.nimble/bin/:$PATH"
ENV NWN_ROOT="${NWSERVER_DATA_PATH}"
# Configure nasher
RUN nasher config --nssFlags:"-lowkey" &&  \
    nasher config --userName:"nasher" &&  \
    nasher config --packUnchanged true && \
    nasher config --abortOnCompileError true

# Configure empty workdir for github to use
RUN mkdir -pv /nasher
WORKDIR /nasher

# Set default command run by container
ENTRYPOINT [ "nasher" ]
CMD [ "--help" ]