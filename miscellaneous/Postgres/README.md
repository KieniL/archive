
## Setup Postgres
Postgres Directory and run setupPostgres.sh
Command for running is:
<shellscript> <usertocreate> <pwforuser> <dbPort> <PostgresPassword> <databasename> <allowed IP And subnet for Connection e.g.192.168.56.1/24>
Examples:
./installpg.sh lukas Kienast 5432 post testdb 192.168.56.1/24
./installpg.sh lukas Kienast 7777 post testdb 192.168.56.1/24
