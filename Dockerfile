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

RUN mkdir mkdir -p ~/bin &&\
    curl https://storage.googleapis.com/git-repo-downloads/repo >~/bin/repo && \
    chmod a+x ~/bin/repo && \
    echo { \
        "# set PATH so it includes user's private bin if it exists" \
        "if [ -d \"$HOME/bin\" ] ; then" \
        "    PATH=\"$HOME/bin:$PATH\"" \
        "fi" \
    } >> ${HOME_DIR}/.profile
ENV PATH=~/bin:$PATH

WORKDIR $HOME_DIR

ADD init.sh $HOME_DIR/init.sh
RUN echo "./init.sh" >> $HOME_DIR/.bashrc

ARG ARB_VERSION
ENV ARB_VERSION=${ARB_VERSION}

ENTRYPOINT ["/bin/bash"]
