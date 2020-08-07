#/bin/sh

#Install pip which is needed for ansible
sudo apt-get install -y python-pip


#Install ansible with pip
sudo pip install --user ansible
sudo apt-get install -y software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

