FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/usr/bin/bash", "-c"]

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y locales sudo

RUN locale-gen en_US.UTF-8 \
 && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US:en
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN adduser --disabled-password --gecos '' docker \
 && adduser docker sudo \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN apt-get update \
 && apt-get install -y \
    curl bash bc gcc-12 sed patch patchutils tar bzip2 gzip xz-utils zstd perl gawk gperf zip \
      unzip diffutils lzop make file g++-12 xfonts-utils xsltproc default-jre-headless python3 \
      libc6-dev libncurses5-dev libjson-perl libxml-parser-perl libparse-yapp-perl rdfind \
      golang-1.23-go git openssh-client rsync upx-ucl \
      python-is-python3 python3 parted wget xxd automake xmlstarlet rsync \
    --no-install-recommends \
    && ln -s /usr/lib/go-1.23 /usr/lib/go \
    && ln -s /usr/lib/go-1.23/bin/go /usr/bin/go \
    && ln -s /usr/lib/go-1.23/bin/gofmt /usr/bin/gofmt

RUN if [ "$(uname -m)" = "aarch64" ]; then \
  apt-get install -y libc6-amd64-cross qemu-user-binfmt --no-install-recommends; \
 fi

RUN rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 100 \
    --slave /usr/bin/cpp cpp /usr/bin/cpp-12 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-12 \
    --slave /usr/bin/gcov gcov /usr/bin/gcov-12
RUN update-alternatives --config gcc

# clang-21 + lld: required to build the SM8550 (Xiaomi Pad 6S Pro) kernel the
# same way the device's proven kernel is built (CC=clang LLVM=1).
RUN wget -O /tmp/llvm.sh https://apt.llvm.org/llvm.sh \
 && chmod +x /tmp/llvm.sh \
 && /tmp/llvm.sh 21 \
 && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-21 100 \
 && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-21 100 \
 && update-alternatives --install /usr/bin/lld lld /usr/bin/lld-21 100 \
 && update-alternatives --install /usr/bin/ld.lld ld.lld /usr/bin/ld.lld-21 100 \
 && update-alternatives --install /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-21 100 \
 && update-alternatives --install /usr/bin/llvm-nm llvm-nm /usr/bin/llvm-nm-21 100 \
 && update-alternatives --install /usr/bin/llvm-objcopy llvm-objcopy /usr/bin/llvm-objcopy-21 100 \
 && update-alternatives --install /usr/bin/llvm-strip llvm-strip /usr/bin/llvm-strip-21 100 \
 && update-alternatives --install /usr/bin/llvm-objdump llvm-objdump /usr/bin/llvm-objdump-21 100 \
 && update-alternatives --install /usr/bin/llvm-readelf llvm-readelf /usr/bin/llvm-readelf-21 100

RUN mkdir -p /nix && chown docker /nix && chmod 777 /nix
RUN mkdir -p /work && chown docker /work

WORKDIR /work

USER docker
