#!/bin/sh

. /vagrant/env.default

if [ -f /vagrant/env ]; then
    source /vagrant/env
fi

# Setup apt-cacher-ng
nc -z 10.0.2.2 3142
if [ $? -eq 0 ]; then
	echo "Host has a working apt-cacher daemon, using the host's one"
    echo "Acquire::http::proxy \"${http_proxy}\";" > /etc/apt/apt.conf.d/01proxy
else
	echo "Could not find a working apt proxy, installing one locally"
	apt-get update > /dev/null
	apt-get install -y apt-cacher-ng
    echo "Acquire::http::proxy \"http://127.0.0.1:3142\";" > /etc/apt/apt.conf.d/01proxy
    http_proxy="http://10.0.2.2:3142"
fi


# Setup packages mirrors
echo "deb http://mirror.switch.ch/ftp/mirror/debian/ jessie-updates main" >> /etc/apt/sources.list.d/jessie-updates.list
echo "deb-src http://mirror.switch.ch/ftp/mirror/debian/ jessie-updates main" >> /etc/apt/sources.list.d/jessie-updates.list

# update
apt-get update
apt-get upgrade -y
apt-get install -y python3 python3-requests vim

# setup build directory
mkdir -p /home/vagrant/client/auto /home/vagrant/client/config /home/vagrant/server/auto /home/vagrant/server/config
chown vagrant:vagrant /home/vagrant/client /home/vagrant/server

mount --rbind /vagrant/client/auto /home/vagrant/client/auto
mount --rbind /vagrant/client/config /home/vagrant/client/config
mount --rbind /vagrant/server/auto /home/vagrant/server/auto
mount --rbind /vagrant/server/config /home/vagrant/server/config

sh /vagrant/vagrant/install_live_build_with_uefi.sh

echo "export http_proxy=${http_proxy}" >> /home/vagrant/.bashrc

ln -s /vagrant/build.py /home/vagrant/build.py
