FROM debian:latest

ARG AdguardHomeVersion=''
ARG NodeVersion=v18.17.0
ARG GoVersion=1.20.7

RUN apt-get update && \
    apt-get install -y git make curl wget gpg zip && \
    apt-get clean

RUN wget https://nodejs.org/dist/${NodeVersion}/node-${NodeVersion}-linux-x64.tar.gz && \
    wget https://go.dev/dl/go${GoVersion}.linux-amd64.tar.gz && \
    tar zxf node-${NodeVersion}-linux-x64.tar.gz -C /usr/local && \
    tar zxf go${GoVersion}.linux-amd64.tar.gz -C /usr/local && \
    rm -f node-${NodeVersion}-linux-x64.tar.gz go${GoVersion}.linux-amd64.tar.gz && \
    mv /usr/local/node-${NodeVersion}-linux-x64 /usr/local/node

WORKDIR /tmp
COPY . .
ENV AdguardHomeVersion=${AdguardHomeVersion}
CMD ./build.sh /build ${AdguardHomeVersion}