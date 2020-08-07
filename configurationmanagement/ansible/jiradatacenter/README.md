Contains Playbooks and Roles to set up Jira DataCenter<br/>
Provisions:
* NFSHost
* DBHost
* Jira Node 1
* Jira Node 2
* ApacheHost


# Modify inventory.yml
If you use a keyfile only ansible_ssh_private_key_file, ansible_user and ansible_become_user need to be used<br/>
If you use passsword comment out ansible_ssh_private_key_file and use the other four credential variables

# Run ansible-playbook playbook.yml -i inventory.yml from this directory
The playbook gets the machines from inventory.yml <br/>
The playbook runs different roles with actions on the machine defined as hosts<br/>
nfshost --> only nfsserver will be installed<br/>
jiranode --> nfsclient and jira will be installed<br/>
dbhost --> only postgres will be installed<br/>
apachehost --> only apache will be installed<br/>


# What is the skript doing?
Installs an nfsserver configuration with two share directories one for jira home and one for jira install names as defined in the inventory<br/>
The directory owner will be the created as deinfed in the inventory with uid 2003.<br/>
installs a postgres server with allowed from all ips. Installs the user, pw and database as defined in inventory<br/>
Installs a apache server withe the jiracluster config defined in templates directory. BalancerMembers will be read from the inventory.yml [jiranode]. DNS Name will be as defnied in the inventory<br/>
For jira nodes it will install nfsclient with user defined in the inventory (userid 2003) and mounts the directory from nfsserver to nfsclient as defined in the inventory<br/>
In Jira role the jirahome and jira install directory are created. Openjdk11 is downloaded and for node1 jira is downloaded and the install to the installshare and homedirectory copies to homeshare<br/>
Edits the cluster.properties in the nodes<br/>

## On First Setup
Autcomment all jiranodes except the first one. Run the setup in jira, delete the comment from the other jiranodes and the run ansible again to configure the next nodes


