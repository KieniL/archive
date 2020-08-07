#!/bin/sh

sudo apt-get update

sudo apt-get install -y postgresql postgresql-contrib

#Get Variables
user=$1
pass=$2
port=$3
postgrespw=$4
databasename=$5
allowedIp=$6

#Create user
sudo  useradd $user
echo "$user:$pass" | sudo chpasswd -e


#get PostgresVersion
pgversion=$(psql -V | cut -d")" -f2 | cut -d"(" -f1 | sed -e 's/^[[:space:]]*//' | cut -d"." -f1)

echo "Postgresversion $pgversion"

if ! [ -z "$port" ]
then
	#Change ListenPort
	sudo  sed -i "s/port = 5432/port = $port/g" /etc/postgresql/$pgversion/main/postgresql.conf
fi

sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses='*'/g" /etc/postgresql/$pgversion/main/postgresql.conf
#Restart Postgresl
sudo service postgresql restart

#Add Host Authenticatioin
echo "host\tall\t\tall\t\t$allowedIp\t\tmd5" | sudo tee -a /etc/postgresql/$pgversion/main/pg_hba.conf
echo "hostssl\tall\t\tall\t\t$allowedIp\t\tmd5" | sudo tee -a /etc/postgresql/$pgversion/main/pg_hba.conf

sudo -u postgres psql -U postgres -c "ALTER USER postgres with password '$postgrespw'";

sudo -u postgres psql -U postgres -c "CREATE USER $user with PASSWORD '$pass';"

sudo -u postgres psql -U postgres -c "CREATE DATABASE $databasename WITH ENCODING 'UTF8'";

sudo -u postgres psql -U postgres -c "ALTER DATABASE $databasename OWNER to $user";

sudo service postgresql restart