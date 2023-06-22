#!/bin/sh

set -e

export PATH="$PATH:/usr/local/go/bin/:/usr/local/node/bin"
export NODE_OPTIONS=--openssl-legacy-provider

ln -s /bin/true /usr/bin/snapcraft

git config --global user.email "b@doubi.fun"
git config --global user.name "B"
git clone --single-branch -b $1 https://github.com/AdguardTeam/AdGuardHome.git
cd AdGuardHome
git am ../patch/*.patch

make ARCH='amd64' OS='linux' CHANNEL='release' SIGN=0 VERSION=$1 build-release
mkdir -p /build
cp dist/AdGuardHome_linux_amd64.tar.gz /build/