FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
    libpthread-stubs0-dev
	
RUN apt-get install -y \
    curl \
    libc6 \
    libgcc1 \
    libgssapi-krb5-2 \
    libicu66 \
    libssl1.1 \
    libstdc++6 \
    zlib1g
	
RUN apt-get install -y \
    build-essential libssl-dev ca-certificates libasound2 wget \
    libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly
	
RUN apt-get install -y \
    ffmpeg

RUN update-ca-certificates

RUN wget -O - https://www.openssl.org/source/openssl-1.1.1u.tar.gz | tar zxf - \
    && cd openssl-1.1.1u \
    && ./config --prefix=/usr/local \
    && make -j $(nproc) \
    && make install_sw install_ssldirs \
    && ldconfig -v \
    && export SSL_CERT_DIR=/etc/ssl/certs

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb --no-check-certificate -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb
	
RUN apt-get update \
	&& apt-get install -y dotnet-runtime-8.0 aspnetcore-runtime-8.0 \
	&& rm -rf /var/lib/apt/lists/*
