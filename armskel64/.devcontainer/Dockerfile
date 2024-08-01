FROM ubuntu:22.04
LABEL maintainer="TC Wan <105933+tcwan@users.noreply.github.com>"
LABEL Description="Image for building and debugging Ubuntu Linux for RPi4 arm-embedded projects from git, adapted from Dockerfile created by Niklas Hauser <niklas.hauser@rwth-aachen.de>\nSource: https://hub.docker.com/r/stronglytyped/arm-none-eabi-gcc/"
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kuala_Lumpur
ARG DIST=jammy
WORKDIR /work

ADD . /work

# Install any needed packages specified in requirements.txt
# Add multiarch support to include cross-build libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
# Development files
      vim \
      build-essential \
      crossbuild-essential-arm64 \
      gdbserver \
      gdb-multiarch \
      liblgpio1 \
      liblgpio-dev \
      librgpio1 \
      librgpio-dev \
      python3 \
      doxygen \
      git \
      bzip2 \
      wget && \
    apt-get clean

