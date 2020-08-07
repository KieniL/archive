# Configuration with SaltStack

Uses Python like Ansible but also a master/slave principle like puppet and chef.<br/>
Because of this a pull principle with jobs is possible<br/>

## Installation
Run installmaster.sh for master<br/>
This will install salt-master<br/>
Run installnode.sh for node<br/>
This will install salt-minion<br/>
Additonally installs the directories for the configuration files

## Configuration

### Master
Create under /etc/salt/master.d/ a file named roots.conf for the environments to use<br/>
There you define this structure:
file_roots:
  base:
    - /srv/salt/base

<br/>
base is the config store file for the root

#### Run command on minion
Run sudo salt 'minonname' command<br/>
e.g sudo salt 'miniontarget' test.ping or<br/>
sudo salt 'miniontarget' cmd.run 'ls -la /home'<br/>
with cmd.run all shell commands are available like in the normal shell

##### Add user on minion from master
Run sudo salt 'miniontarget' user.add name <uid> <groups> <home> <shell><br/>
e.g. sudo salt 's*' user.add 'testing'

##### Create motd file
sudo salt 'miniontarget' file.append /etc/motd 'Message'

##### Install packages from master on minion
sudo salt 'miniontarget' pkg.install <packagename>

#### see Minions
run sudo salt-key<br/>
This will show the name of the minions and their key status

#### Accept key
Run sudo salt-key -a 'minionname'<br/>
You you also use wildmarks like: sudo salt-key -a 'salt-ma*'

### Minion
Create a master.conf file under /etc/salt/minion.d/ to define where the master is located<br/>
Structure is as follows:
master: IPorDNSName like master: localhost<br/>

#### Create Minion in daemon mode
Run sudo salt-minion -d to create minion<br/>
You will see it now under sudo salt-key under Unaccepted keys (Could need a minute)

#### Kill minion
Run sudo pkill -9 salt-minion<br/>
Also run sudo salt-key -d 'dnsname under salt-key' to kill the key

#### Rename minion
Under /etc/salt create a file named minion_id to set the name of the minion


### Create Configurations to load
Create a pillar and a base folder in the diretory defined in roots.conf
Creaate a top.sls file in the salt folder(see learning project https://github.com/Kreidl/learning) )<br/>
Start with the base and declare which packages should exist on all nodes<br/>
Define it in this structure:<br/>
base:
  '\*': (Without \)
    - requirements
    - users
    - ssh
    - logging

<br/>
All this items in array could exist in the same directory as top.sls but <br/>
it is recommended to create the name of this item as a directory and the a <br/>
init.sls in this directory<br/>
In the pillar folder define variables (see learning project)<br/>
In this project users are defined in the pillar and the iterate it in salt/users/init.sls<br/>
copy the learning directory content to your defined base directory in /etc/salt/master.d/roots.conf
