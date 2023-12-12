FROM ubuntu:20.04

LABEL org.opencontainers.image.source="https://github.com/tushroy/az-speech-dotnet-docker" \
      org.opencontainers.image.description="az-speech-dotnet" \
      org.opencontainers.image.licenses="GPL-3.0-or-later"

ENV HOSTNAME=az-speech-dotnet

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
    build-essential libssl-dev ca-certificates libasound2 wget
	
RUN	apt-get install -y \
    libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly
	
RUN apt-get install -y \
    ffmpeg

RUN wget -O - https://www.openssl.org/source/openssl-1.1.1u.tar.gz | tar zxf - 
WORKDIR /openssl-1.1.1u
RUN ./config --prefix=/usr/local \
    && make -j $(nproc) \
    && make install_sw install_ssldirs \
    && ldconfig -v \
    && export SSL_CERT_DIR=/etc/ssl/certs
WORKDIR /
RUN rm -rf /openssl-1.1.1u
ENV SSL_CERT_DIR=/etc/ssl/certs

RUN update-ca-certificates

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb --no-check-certificate -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb
	
RUN apt-get update \
	&& apt-get install -y dotnet-runtime-8.0 aspnetcore-runtime-8.0 \
	&& rm -rf /var/lib/apt/lists/*