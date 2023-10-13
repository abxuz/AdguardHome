#!/bin/sh

set -e

apt-get update
apt-get install -y git make curl wget gpg zip

NodeVersion=v18.18.1
GoVersion=1.21.3
if [ -z $AdGuardHomeVersion ]; then
    AdGuardHomeVersion=$(curl https://github.com/AdguardTeam/AdGuardHome/releases/latest -v 2>&1 | grep tag | awk -F '/tag/' '{print $2}' | tr -d '\0-\31\177')
fi

rm -rf build
mkdir build
cd build

wget https://nodejs.org/dist/${NodeVersion}/node-${NodeVersion}-linux-x64.tar.gz -q
tar zxf node-${NodeVersion}-linux-x64.tar.gz -C /usr/local
mv /usr/local/node-${NodeVersion}-linux-x64 /usr/local/node
rm -f node-${NodeVersion}-linux-x64.tar.gz

wget https://go.dev/dl/go${GoVersion}.linux-amd64.tar.gz -q
tar zxf go${GoVersion}.linux-amd64.tar.gz -C /usr/local
rm -f go${GoVersion}.linux-amd64.tar.gz

export PATH="$PATH:/usr/local/go/bin/:/usr/local/node/bin"
export NODE_OPTIONS=--openssl-legacy-provider

ln -s /bin/true /usr/bin/snapcraft

git config --global user.email "b@doubi.fun"
git config --global user.name "B"
git clone --single-branch -b $AdGuardHomeVersion https://github.com/AdguardTeam/AdGuardHome.git
cd AdGuardHome
git am ../../patch/*.patch

make ARCH='amd64' OS='linux' CHANNEL='release' SIGN=0 VERSION=$AdGuardHomeVersion build-release
mv dist/AdGuardHome_linux_amd64.tar.gz ../
