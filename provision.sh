#!/bin/sh

echo "Updating system..."
apt-get update > /dev/null 2>&1
echo "Upgrading system packages..."
apt-get -y upgrade > /dev/null 2>&1

echo "Adding mono to sources list and installing mono, unzip."
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > /dev/null 2>&1
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
apt-get -y update > /dev/null 2>&1
apt-get -y install mono-complete unzip > /dev/null 2>&1

echo "Downloading and configuring libuv."
apt-get -y install automake libtool curl
curl -sSL https://github.com/libuv/libuv/archive/v1.4.2.tar.gz | sudo tar zxfv - -C /usr/local/src
cd /usr/local/src/libuv-1.4.2
sh autogen.sh > /dev/null 2>&1
./configure && make && make install > /dev/null 2>&1
rm -rf /usr/local/src/libuv-1.4.2 && cd ~/
ldconfig > /dev/null 2>&1

echo "Installing dnvm for vagrant."
su vagrant -c "curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_BRANCH=dev sh" > /dev/null 2>&1

# Remove previous timestamp-started file.
if [ -f /home/vagrant/started ];
then
	echo "Clearing previous started file."
	rm /home/vagrant/started
fi

# Create started file with timestamp.
touch /home/vagrant/started
echo "Timestamp file created under /home/vagrant/started"
