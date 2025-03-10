FROM python:3.9-bullseye

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y lua5.1 wget
RUN wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz && \
  tar zxpf luarocks-3.11.1.tar.gz && \
  cd luarocks-3.11.1 && \
  ./configure --with-lua=/usr/local && \
  make && \
  sudo make install
