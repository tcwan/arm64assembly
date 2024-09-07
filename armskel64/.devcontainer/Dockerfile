# Make sure to define PLATFORM build-arg: arm64 or amd64
# docker build --build-arg PLATFORM=xxxx .
FROM ubuntu:24.04
LABEL maintainer="TC Wan <105933+tcwan@users.noreply.github.com>"
LABEL Description="Image for building and debugging Ubuntu Linux for RPi5 arm-embedded projects from git, adapted from Dockerfile created by Niklas Hauser <niklas.hauser@rwth-aachen.de>\nSource: https://hub.docker.com/r/stronglytyped/arm-none-eabi-gcc/"
ENV TZ=Asia/Kuala_Lumpur
ARG PLATFORM
ARG DIST=noble
WORKDIR /work

ADD . /work

# Install any needed packages specified in requirements.txt
# Add multiarch support to include cross-build libraries
RUN dpkg --add-architecture arm64 && \
    if [ "$PLATFORM" = "arm64" ]; then \
        sed -i 's/^Types: deb$/Types: deb\nArchitectures: arm64/g' /etc/apt/sources.list.d/ubuntu.sources ; \
    elif [ "$PLATFORM" = "amd64" ]; then \
        sed -i 's/^Types: deb$/Types: deb\nArchitectures: amd64/g' /etc/apt/sources.list.d/ubuntu.sources ; \
    else \
      echo "Unknown PLATFORM" && \
      exit 1; \
    fi
RUN \    
    cp /work/${DIST}-arm64.sources /etc/apt/sources.list.d/ && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
# Development files
      vim \
      build-essential \
      crossbuild-essential-arm64 \
      gdbserver \
      gdb-multiarch \
      liblgpio1:arm64 \
      liblgpio-dev:arm64 \
      librgpio1:arm64 \
      librgpio-dev:arm64 \
      python3 \
      doxygen \
      git \
      bzip2 \
      openssh-client \
      wget && \
    apt-get clean

