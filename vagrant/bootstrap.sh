#!/usr/bin/env bash

# Setup apt-cacher-ng
if [ `nc -z 127.0.0.1 3142` ]; then
	echo "Host has a working apt-cacher daemon, using the host's one"
else
	echo "Could not find a working apt proxy, installing one locally"
	apt-get update > /dev/null
	apt-get install -y apt-cacher-ng

	echo "CacheDir: /vagrant/.cache/apt-cacher-ng" > /etc/apt-cacher-ng/zzz_override.conf
	systemctl restart apt-cacher-ng
fi
echo "Acquire::http::proxy \"http://127.0.0.1:3142\";" > /etc/apt/apt.conf.d/01proxy


# Setup packages mirrors
echo "deb http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list.d/jessie-updates.list
echo "deb-src http://httpredir.debian.org/debian jessie-updates main" >> /etc/apt/sources.list.d/jessie-updates.list

# update
apt-get update
apt-get upgrade -y
apt-get install -y live-build python3

# setup build directory
mkdir -p /home/vagrant/{client,server}/{auto,config}
chown vagrant:vagrant /home/vagrant/{client,server}

mount --rbind {,/home}/vagrant/client/auto
mount --rbind {,/home}/vagrant/client/config
mount --rbind {,/home}/vagrant/server/auto
mount --rbind {,/home}/vagrant/server/config

sh /vagrant/vagrant/install_live_build_with_uefi.sh
