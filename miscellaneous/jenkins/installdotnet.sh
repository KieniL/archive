#/bin/sh

wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo add-apt-repository universe
sudo apt-get update && sudo apt-get install -y apt-transport-https  dotnet-sdk-3.1
