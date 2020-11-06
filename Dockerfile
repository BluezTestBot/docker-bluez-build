FROM ubuntu:19.10

ARG ELL_VER=0.33

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get clean && \
	apt-get -y update && \
	apt-get install --no-install-recommends -y \
		autoconf \
		automake \
		autotools-dev \
		bc \
		bison \
		build-essential \
		ca-certificates \
		clang-tools \
		curl \
		dkms \
		flex \
		git \
		git-core \
		libasound2-dev \
		libdbus-1-dev \
		libdw-dev \
		libelf-dev \
		libglib2.0-dev \
		libiberty-dev \
		libical-dev \
		libjson-c-dev \
		libncurses-dev \
		libpci-dev \
		libreadline-dev \
		libsbc-dev \
		libspeexdsp-dev \
		libssl-dev \
		libsystemd-dev \
		libtool \
		libudev-dev \
		locales \
		openssl \
		patch \
		pkg-config \
		python3 \
		python3-pip \
		systemd \
		udev \
		wget \
		xxd && \
	rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl -P /usr/bin/ && \
	chmod +x /usr/bin/checkpatch.pl

RUN wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/spelling.txt -P /usr/bin/ && \
	touch /usr/bin/const_structs.checkpatch

RUN pip3 install --no-cache-dir setuptools

COPY requirements.txt /

RUN pip3 install --no-cache-dir -r /requirements.txt

# Install ell
RUN git clone https://git.kernel.org/pub/scm/libs/ell/ell.git /ell && \
	cd /ell && \
	git checkout -b ${ELL_VER} tags/${ELL_VER} && \
	./bootstrap-configure && \
	make && \
	make install
