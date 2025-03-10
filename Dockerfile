FROM python:3.9-bullseye

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y luarocks
RUN luarocks install busted
