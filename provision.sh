#!/bin/sh

echo "Updating system..."
apt-get update > /dev/null 2>&1
echo "Upgrading system packages..."
apt-get -y upgrade > /dev/null 2>&1

echo "Adding mono to sources list and installing mono, unzip, git."
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > /dev/null 2>&1
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
apt-get -y update > /dev/null 2>&1
apt-get -y install mono-complete unzip git > /dev/null 2>&1

echo "Downloading and configuring libuv."
apt-get -y install automake libtool curl > /dev/null 2>&1
curl -sSL https://github.com/libuv/libuv/archive/v1.4.2.tar.gz | sudo tar zxfv - -C /usr/local/src > /dev/null 2>&1
cd /usr/local/src/libuv-1.4.2
sh autogen.sh > /dev/null 2>&1
./configure && make && make install > /dev/null 2>&1
rm -rf /usr/local/src/libuv-1.4.2 && cd ~/
ldconfig > /dev/null 2>&1

echo "Installing dnvm for vagrant, using the dev DNX branch (beta6 - you may need to update this for a working demo!)"
su vagrant -c "curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_BRANCH=dev sh" > /dev/null 2>&1
# for testing against my own fork:
# su vagrant -c "curl -sSL https://raw.githubusercontent.com/ajduncan/Home/dev/dnvminstall.sh | DNX_BRANCH=dev DNVM_SOURCE=https://raw.githubusercontent.com/ajduncan/Home/dev/dnvm.sh sh" > /dev/null 2>&1

if [ ! -d /home/vagrant/.config ];
then
  echo "Installing NuGet config file for vagrant user."
  su vagrant -c "mkdir -p /home/vagrant/.config/NuGet" > /dev/null 2>&1
  su vagrant -c "cp /vagrant/NuGet.Config /home/vagrant/.config/NuGet/NuGet.Config" > /dev/null 2>&1
fi

echo "Upgrading dnvm."
su vagrant -c ". /home/vagrant/.dnx/dnvm/dnvm.sh && dnvm upgrade" > /dev/null 2>&1

if [ ! -d /vagrant/Home ];
then
  echo "Cloning https://github.com/aspnet/Home to /vagrant"
  su vagrant -c "cd /vagrant && git clone https://github.com/aspnet/Home" > /dev/null 2>&1
fi

if [ -d /vagrant/Home/samples/1.0.0-beta6/HelloWeb ];
then
  # this sometimes fails, so don't trap output to dev/null
  echo "Installing the beta6 HelloWeb app dependencies via dnu restore."
  su vagrant -c ". /home/vagrant/.dnx/dnvm/dnvm.sh && cd /vagrant/Home/samples/1.0.0-beta6/HelloWeb && MONO_THREADS_PER_CPU=2000 dnu restore"
fi

# Remove previous timestamp-started file.
if [ -f /home/vagrant/started ];
then
	echo "Clearing previous started file."
	rm /home/vagrant/started
fi

# Create started file with timestamp.
touch /home/vagrant/started
echo "Timestamp file created under /home/vagrant/started"
