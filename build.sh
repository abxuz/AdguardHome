#!/bin/sh

set -e

DESTDIR=$1
VERSION=$2

if [ -z $VERSION ]; then
    VERSION=$(curl https://github.com/AdguardTeam/AdGuardHome/releases/latest -v 2>&1 | grep tag | awk -F '/tag/' '{print $2}')
fi

export PATH="$PATH:/usr/local/go/bin/:/usr/local/node/bin"
export NODE_OPTIONS=--openssl-legacy-provider

ln -s /bin/true /usr/bin/snapcraft

git config --global user.email "b@doubi.fun"
git config --global user.name "B"
git clone --single-branch -b $VERSION https://github.com/AdguardTeam/AdGuardHome.git
cd AdGuardHome
git am ../patch/*.patch

make ARCH='amd64' OS='linux' CHANNEL='release' SIGN=0 VERSION=$VERSION build-release
mkdir -p $DESTDIR
cp dist/AdGuardHome_linux_amd64.tar.gz $DESTDIR/AdGuardHome_linux_amd64.tar.gz