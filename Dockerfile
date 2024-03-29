FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		autoconf \
		automake \
		autotools-dev \
		bc \
		bear \
		bison \
		build-essential \
		ca-certificates \
		clang-tools \
		cmake \
		cppcheck \
		curl \
		dkms \
		fakeroot \
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
		libsqlite3-dev \
		libssl-dev \
		libsystemd-dev \
		libtool \
		libudev-dev \
		libxml2-dev \
		locales \
		openssl \
		patch \
		pkg-config \
		python-docutils \
		python-pygments \
		python3 \
		python3-pip \
		python3-docutils \
		python3-pygments \
		qemu-system-x86 \
		systemd \
		udev \
		valgrind \
		wget \
		xxd && \
	rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Install Python3 Library
RUN pip3 install --no-cache-dir setuptools && \
	pip3 install --no-cache-dir gitlint gitpython junitparser pygithub requests ply

RUN wget --no-verbose --no-check-certificate \
	https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl -P /usr/bin/ && \
	chmod +x /usr/bin/checkpatch.pl

RUN wget --no-verbose --no-check-certificate \
	https://raw.githubusercontent.com/torvalds/linux/master/scripts/spelling.txt -P /usr/bin/ && \
	touch /usr/bin/const_structs.checkpatch

# Install Sparse tool
RUN git clone https://git.kernel.org/pub/scm/devel/sparse/sparse.git /sparse && \
	cd /sparse && make && make PREFIX=/usr install && rm -rf /sparse

# Install smatch tool
RUN git clone https://repo.or.cz/smatch.git /smatch && \
	cd /smatch && make

