FROM python:3.9-bullseye

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG LUAROCKS_VERSION=3.11.1
ARG NEOVIM_VERSION=v0.10.4

# Install system packages.
RUN apt-get update && apt-get install -y cmake gettext liblua5.1 lua5.1 wget;

# Build and install neovim from source.
RUN mkdir -p /build/neovim && \
    git clone https://github.com/neovim/neovim /build/neovim && \
    cd /build/neovim && \
    git checkout $NEOVIM_VERSION && \
    make CMAKE_BUILD_TYPE=Release -j && \
    make install;

# Build and install luarocks from source.
RUN wget https://luarocks.org/releases/luarocks-$LUAROCKS_VERSION.tar.gz && \
  tar zxpf luarocks-$LUAROCKS_VERSION.tar.gz && \
  cd luarocks-$LUAROCKS_VERSION && \
  ./configure && \
  make && \
  make install;

# Install luarocks packages and add ~/.luarocks/bin to PATH.
RUN luarocks install busted && \
  luarocks install nlua && \
  luarocks install luacov;
RUN printf 'export PATH=$PATH:$HOME/.luarocks/bin\n' >> /bashrc;
