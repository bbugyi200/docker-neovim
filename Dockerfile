FROM python:3.9-bullseye

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# VERSION FRESHNESS: 2025-04-11
# 
# Update the above date after updating the version numbers below to the latest
# stable release of each tool. The latest stable releases can be found at:
#
# - LLS: https://github.com/LuaLS/lua-language-server/releases
# - LUAROCKS: https://luarocks.org/releases
# - NEOVIM: https://github.com/neovim/neovim/tags
ARG LLS_VERSION=3.14.0
ARG LUAROCKS_VERSION=3.11.1
ARG NEOVIM_VERSION=v0.11.0

# Install system packages.
RUN apt-get update && apt-get install -y cmake gettext liblua5.1 lua5.1 ninja-build wget;

# Build and install neovim from source.
RUN mkdir -p /build/neovim && \
    git clone https://github.com/neovim/neovim /build/neovim && \
    cd /build/neovim && \
    git checkout $NEOVIM_VERSION && \
    make CMAKE_BUILD_TYPE=Release -j && \
    make install;

# Build and install lua-language-server from source.
RUN mkdir -p /build/lua-language-server && \
    git clone https://github.com/LuaLS/lua-language-server /build/lua-language-server && \
    cd /build/lua-language-server && \
    git checkout $LLS_VERSION && \
    ./make.sh && \
    chmod -R a+rw /build/lua-language-server;
ENV PATH="${PATH}:/build/lua-language-server/bin"


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
  luarocks install llscheck && \
  luarocks install luacheck && \
  luarocks install luacov;
