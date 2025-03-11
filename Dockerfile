FROM alpine:3.18

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# Install system packages and build dependencies
RUN apk add --no-cache \
    bash \
    cmake \
    g++ \
    gcc \
    gettext-dev \
    git \
    libc-dev \
    lua5.1-dev \
    make \
    wget;

# Build and install neovim from source
RUN mkdir -p /build/neovim && \
    git clone https://github.com/neovim/neovim /build/neovim && \
    cd /build/neovim && \
    git checkout v0.$(git tag | cut -c4- | grep '[0-9]' | sort -n | tail -n 1) && \
    make CMAKE_BUILD_TYPE=Release -j && \
    make install;

# Build and install luarocks from source
RUN wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz && \
    tar zxpf luarocks-3.11.1.tar.gz && \
    cd luarocks-3.11.1 && \
    ./configure && \
    make && \
    make install;

# Install luarocks packages and add ~/.luarocks/bin to PATH
RUN luarocks install busted && \
    luarocks install nlua && \
    luarocks install luacov;
RUN printf 'export PATH=$PATH:$HOME/.luarocks/bin\n' >> /etc/profile;
