FROM ubuntu:20.04

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
		qemu-system-x86 \
		systemd \
		udev \
		wget \
		xxd && \
	rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install ell
RUN git clone https://git.kernel.org/pub/scm/libs/ell/ell.git /ell && \
	cd /ell && \
	./bootstrap-configure && \
	make && \
	make install

COPY requirements.txt /
RUN pip3 install --no-cache-dir setuptools
RUN pip3 install --no-cache-dir -r /requirements.txt

RUN wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl -P /usr/bin/ && \
	chmod +x /usr/bin/checkpatch.pl

RUN wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/spelling.txt -P /usr/bin/ && \
	touch /usr/bin/const_structs.checkpatch

# Install Coverity Tools
RUN wget https://scan.coverity.com/download/linux64 --post-data "token=OEYFXTX4NE6EvfqnBPAf_w&project=BluezTestBot%2Fbluez" -O /coverity_tool.tgz
RUN mkdir /opt/cov-tools
RUN tar -xvzf /coverity_tool.tgz -C /opt/cov-tools/ --strip-components=1
RUN rm /coverity_tool.tgz
ENV PATH="/opt/cov-tools/bin:${PATH}"

# Install Cppcheck
ENV CPPCHECK_VER=2.4
RUN git clone https://github.com/danmar/cppcheck /opt/cppcheck && \
	cd /opt/cppcheck && git checkout $CPPCHECK_VER && \
	mkdir build && cd build && \
	cmake .. -DCMAKE_BUILD_TYPE=Release -DUSE_MATCHCOMPILER=yes && \
	cmake --build .
ENV PATH="/opt/cppcheck/build/bin:${PATH}"
