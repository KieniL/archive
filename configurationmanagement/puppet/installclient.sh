#/bin/sh

sudo wget https://apt.puppetlabs.com/puppet-release-bionic.deb
sudo dpkg -i puppet-release-bionic.deb
sudo apt-get install-y puppet
