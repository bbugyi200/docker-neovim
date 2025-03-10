FROM python:3.9-bullseye

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz && \
  tar zxpf luarocks-3.11.1.tar.gz && \
  cd luarocks-3.11.1 && \
  ./configure --lua-version=5.1 && \
  make && \
  sudo make install
