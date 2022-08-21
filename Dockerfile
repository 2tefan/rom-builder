ARG LINUX_DISTRO
ARG LINUX_DISTRO_RELEASE

FROM ${LINUX_DISTRO}:${LINUX_DISTRO_RELEASE}
ARG HOME_DIR=/root

ENV DEBIAN_FRONTEND='noninteractive'

RUN apt-get clean && \
    apt-get update && \
    apt-get -y dist-upgrade

RUN apt-get update && \
    apt-get install -y \
        bc \
        bison \
        build-essential \
        ccache \
        curl \
        flex \
        g++-multilib \
        gcc-multilib \
        git \
        gnupg \
        gperf \
        imagemagick \
        lib32ncurses5-dev \
        lib32readline-dev \
        lib32z1-dev \
        liblz4-tool \
        libncurses5 \
        libncurses5-dev \
        libsdl1.2-dev \
        libssl-dev \
        libwxgtk3.0-gtk3-dev \
        libxml2 \
        libxml2-utils \
        lzop \
        pngcrush \
        python \
        rsync \
        schedtool \
        squashfs-tools \
        xsltproc \
        zip \
        zlib1g-dev

RUN apt-get update && \
    apt-get install -y \
        android-sdk-platform-tools

RUN apt-get update && \
    apt-get install -y \
        nano \
        neovim

ADD setup/arb.sh $HOME_DIR/.arb
ADD build/setup.sh $HOME_DIR/setup.sh
RUN $HOME_DIR/setup.sh
RUN rm $HOME_DIR/setup.sh

WORKDIR $HOME_DIR

ADD setup/init.sh $HOME_DIR/init.sh
RUN echo "./init.sh" >> $HOME_DIR/.bashrc

ARG ARB_VERSION
ENV ARB_VERSION=${ARB_VERSION}

ENTRYPOINT ["/bin/bash"]
