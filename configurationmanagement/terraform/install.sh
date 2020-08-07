#/bin/sh

sudo apt-get install -y unzip

sudo wget https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip

sudo unzip terraform_0.12.23_linux_amd64.zip

sudo mv terraform /usr/local/bin
