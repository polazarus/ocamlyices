FROM ubuntu:22.04 AS dev
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y build-essential m4 autoconf npm curl git libgmp-dev libmpfr-dev && apt-get clean
RUN npm install -g --unsafe-perm esy

WORKDIR /root/vendor/
RUN apt install -y wget
RUN wget https://yices.csl.sri.com/old/binaries/yices-1.0.40-x86_64-unknown-linux-gnu.tar.gz
COPY install-yices.sh .
RUN bash install-yices.sh ./yices-1.0.40-x86_64-unknown-linux-gnu.tar.gz


FROM dev
WORKDIR /workspaces/ocamlyices/
COPY . /workspaces/ocamlyices/
RUN esy