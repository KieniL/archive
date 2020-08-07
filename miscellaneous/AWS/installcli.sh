#/bin/sh

#Install awscli
sudo apt-get install -y awscli

accessKey=$1
secretKey=$2
defaultregion=$3

#Configure cli to authenticate
aws configure set aws_access_key_id $accessKey
aws configure set aws_secret_access_key $secretKey
aws configure set default.region $defaultregion
